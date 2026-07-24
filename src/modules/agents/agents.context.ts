import fs from 'fs/promises';
import path from 'path';
import { getMetadataPath } from '../workspace';
import type { AgentDefinition } from './agents.types';

const METADATA_FILES = ['architecture.md', 'coding_rules.md', 'glossary.md'] as const;
const MAX_HISTORY_ENTRIES = 5;

const DEFAULT_AGENT_ROLE = `You are an AI development agent working on a software project. Your role is to analyze the codebase, understand the task, and propose precise code changes.`;

const OUTPUT_INSTRUCTIONS = `
## REQUIRED OUTPUT FORMAT

You MUST end your response with ONLY a raw JSON object. Do not wrap it in markdown code blocks. Do not add any text after the JSON. The JSON must have this exact structure:

{
  "summary": "What was analyzed and proposed in natural language",
  "proposed_changes": [
    { "action": "create", "path": "src/foo.ts", "content": "full file content here" },
    { "action": "edit", "path": "src/bar.ts", "content": "full updated file content here" },
    { "action": "delete", "path": "src/old.ts" }
  ]
}

Rules:
- "action" must be one of: "create", "edit", "delete"
- "path" must be relative to the repository root (e.g., "src/app.ts", not "/src/app.ts")
- "content" is required for "create" and "edit", must be omitted for "delete"
- "summary" must be a non-empty string
- If no file changes are needed, use an empty array: "proposed_changes": []
- Output ONLY the JSON object as the last thing in your response — nothing after the closing brace`;

export class AgentContextBuilder {
  async build(workspaceId: string, agent?: AgentDefinition): Promise<string> {
    const metadataPath = getMetadataPath(workspaceId);
    const loadedFiles = await this.loadMetadataFiles(metadataPath);
    const historySection = await this.loadHistorySection(metadataPath);
    const roleText = agent?.role ?? DEFAULT_AGENT_ROLE;

    if (loadedFiles.length === 0 && !historySection) {
      return `${roleText}\n${OUTPUT_INSTRUCTIONS}`;
    }

    const parts: string[] = [roleText];

    if (loadedFiles.length > 0) {
      const contextSections = loadedFiles
        .map(({ name, content }) => `## ${name}\n\n${content}`)
        .join('\n\n');
      parts.push(`\n## Project Context\n\n${contextSections}`);
    }

    if (historySection) {
      parts.push(historySection);
    }

    parts.push(OUTPUT_INSTRUCTIONS);

    return parts.join('\n');
  }

  private async loadMetadataFiles(metadataPath: string): Promise<{ name: string; content: string }[]> {
    const results: { name: string; content: string }[] = [];

    for (const fileName of METADATA_FILES) {
      try {
        const content = await fs.readFile(path.join(metadataPath, fileName), 'utf-8');
        results.push({ name: fileName, content });
      } catch {
        // file absent — omit silently per RN-03
      }
    }

    return results;
  }

  private async loadHistorySection(metadataPath: string): Promise<string> {
    const historyDir = path.join(metadataPath, 'history');

    let fileNames: string[];
    try {
      const entries = await fs.readdir(historyDir);
      fileNames = entries.filter((f) => f.endsWith('.md')).sort();
    } catch (err) {
      if ((err as NodeJS.ErrnoException).code === 'ENOENT') return '';
      throw err;
    }

    const recentFiles = fileNames.slice(-MAX_HISTORY_ENTRIES);
    if (recentFiles.length === 0) return '';

    const contents = await Promise.all(
      recentFiles.map((f) => fs.readFile(path.join(historyDir, f), 'utf-8')),
    );

    return `\n## Execution History\n\n${contents.join('\n\n---\n\n')}`;
  }
}
