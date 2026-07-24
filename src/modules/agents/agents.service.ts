import fs from 'fs/promises';
import path from 'path';
import Anthropic from '@anthropic-ai/sdk';
import type { MessageParam, Tool, Message } from '@anthropic-ai/sdk/resources/messages';
import { getRepositoryPath } from '../workspace';
import { AgentTask, AgentResult, ProposedChange, AgentDefinition } from './agents.types';
import { AgentApiError, AgentConfigError } from './agents.errors';
import { AgentContextBuilder } from './agents.context';
import { saveHistory } from './agents.history';

const MODEL = 'claude-sonnet-4-6';
const MAX_TOKENS = 8192;

const AGENT_TOOLS: Tool[] = [
  {
    name: 'read_file',
    description: 'Read the contents of a file in the repository.',
    input_schema: {
      type: 'object',
      properties: {
        path: { type: 'string', description: 'Path relative to the repository root.' },
      },
      required: ['path'],
    },
  },
  {
    name: 'list_directory',
    description: 'List entries in a directory in the repository.',
    input_schema: {
      type: 'object',
      properties: {
        path: { type: 'string', description: 'Path relative to the repository root.' },
      },
      required: ['path'],
    },
  },
];

export class AgentService {
  private readonly contextBuilder: AgentContextBuilder;

  constructor() {
    this.contextBuilder = new AgentContextBuilder();
  }

  async run(
    workspaceId: string,
    task: AgentTask,
    agent?: AgentDefinition,
    skipHistory?: boolean,
  ): Promise<AgentResult> {
    const apiKey = process.env.ANTHROPIC_API_KEY;
    if (!apiKey) {
      throw new AgentConfigError('ANTHROPIC_API_KEY environment variable is not set');
    }

    const systemPrompt = await this.contextBuilder.build(workspaceId, agent);
    const repositoryPath = getRepositoryPath(workspaceId);
    const executionId = new Date().toISOString();

    const client = new Anthropic({ apiKey });
    const messages: MessageParam[] = [{ role: 'user', content: task.description }];

    let finalText = '';
    let tokensUsed = 0;

    try {
      while (true) {
        const response = await client.messages.create({
          model: MODEL,
          max_tokens: MAX_TOKENS,
          system: systemPrompt,
          tools: AGENT_TOOLS,
          messages,
        } as unknown as Parameters<typeof client.messages.create>[0]) as unknown as Message;

        tokensUsed += response.usage.input_tokens + response.usage.output_tokens;

        if (response.stop_reason === 'end_turn') {
          const textBlock = response.content.find(
            (block: { type: string }) => block.type === 'text',
          ) as { type: 'text'; text: string } | undefined;

          finalText = textBlock?.text ?? '';
          break;
        }

        if (response.stop_reason === 'tool_use') {
          const assistantMessage = { role: 'assistant' as const, content: response.content };
          messages.push(assistantMessage);

          const toolResults = await this.processToolCalls(response.content, repositoryPath);
          messages.push({ role: 'user', content: toolResults });
        }
      }
    } catch (err) {
      if (err instanceof AgentApiError) throw err;
      throw new AgentApiError(err instanceof Error ? err.message : 'Claude API call failed');
    }

    const { summary, proposedChanges } = this.parseAgentResponse(finalText);

    if (!skipHistory) {
      await saveHistory(workspaceId, executionId, task, summary, proposedChanges, tokensUsed);
    }

    return { summary, proposedChanges, tokensUsed, executionId };
  }

  private async processToolCalls(
    contentBlocks: Message['content'],
    repositoryPath: string,
  ): Promise<{ type: 'tool_result'; tool_use_id: string; content: string }[]> {
    const toolUseBlocks = (contentBlocks as unknown as { type: string; [key: string]: unknown }[]).filter(
      (block) => block.type === 'tool_use',
    ) as { type: 'tool_use'; id: string; name: string; input: { path: string } }[];

    const results = await Promise.all(
      toolUseBlocks.map(async (block) => {
        const content = await this.executeTool(block.name, block.input.path, repositoryPath);
        return { type: 'tool_result' as const, tool_use_id: block.id, content };
      }),
    );

    return results;
  }

  private async executeTool(
    toolName: string,
    requestedPath: string,
    repositoryPath: string,
  ): Promise<string> {
    const resolvedPath = path.resolve(repositoryPath, requestedPath);

    if (!resolvedPath.startsWith(repositoryPath)) {
      return `Error: access denied — path "${requestedPath}" is outside the repository`;
    }

    if (toolName === 'read_file') {
      try {
        return await fs.readFile(resolvedPath, 'utf-8');
      } catch {
        return `Error: could not read file "${requestedPath}"`;
      }
    }

    if (toolName === 'list_directory') {
      try {
        const entries = await fs.readdir(resolvedPath);
        return entries.join('\n');
      } catch {
        return `Error: could not list directory "${requestedPath}"`;
      }
    }

    return `Error: unknown tool "${toolName}"`;
  }

  private parseAgentResponse(text: string): { summary: string; proposedChanges: ProposedChange[] } {
    const jsonBlockMatch = text.match(/```json\s*([\s\S]*?)```/);
    const jsonCandidate = jsonBlockMatch ? jsonBlockMatch[1] : this.extractRawJsonArray(text);

    if (jsonCandidate === null) {
      throw new AgentApiError('Claude response did not contain a valid JSON block');
    }

    try {
      const parsed = JSON.parse(jsonCandidate);
      if (parsed && typeof parsed === 'object' && !Array.isArray(parsed)) {
        return {
          summary: String(parsed.summary ?? text),
          proposedChanges: Array.isArray(parsed.proposed_changes) ? parsed.proposed_changes : [],
        };
      }
      if (Array.isArray(parsed)) {
        return { summary: text, proposedChanges: parsed };
      }
    } catch {
      throw new AgentApiError('Claude response contained invalid JSON');
    }

    return { summary: text, proposedChanges: [] };
  }

  private extractRawJsonArray(text: string): string | null {
    const arrayMatch = text.match(/(\[[\s\S]*\])/);
    return arrayMatch ? arrayMatch[1] : null;
  }

}
