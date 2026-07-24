import { EventEmitter } from 'events';
import path from 'path';
import { WorkspaceService } from '../workspace/workspace.service';
import { WorkspaceStatus } from '../workspace/workspace.types';
import { WorkspaceNotFoundError, getMetadataPath } from '../workspace';
import { createRuntime } from '../runtime/runtime.factory';
import { saveHistory } from '../agents/agents.history';
import { ExecutionService } from '../execution';
import { GitService } from '../git';
import type { Runtime } from '../runtime/runtime.types';
import type { ExecutionResult } from '../execution';
import type { TaskType, ExecutionState, OrchestratorEvent, OrchestratorResult } from './orchestrator.types';
import { WorkspaceBusyError, WorkspaceNotReadyError, AbortedError } from './orchestrator.errors';

const ANALYSIS_KEYWORDS = ['analise', 'explique', 'descreva', 'por que', 'como funciona'];
const QUESTION_KEYWORDS = ['o que é', 'qual', 'quem', 'quando', 'onde'];

export class OrchestratorService extends EventEmitter {
  private readonly workspaceService: WorkspaceService;
  private readonly executionService: ExecutionService;
  private readonly locks: Map<string, boolean>;
  private readonly abortSignals: Map<string, boolean>;
  private readonly states: Map<string, ExecutionState>;
  private runtime: Runtime | null;

  constructor() {
    super();
    this.workspaceService = new WorkspaceService();
    this.executionService = new ExecutionService(new GitService());
    this.locks = new Map();
    this.abortSignals = new Map();
    this.states = new Map();
    this.runtime = null;
  }

  getState(workspaceId: string): ExecutionState {
    return this.states.get(workspaceId) ?? 'idle';
  }

  async abort(workspaceId: string): Promise<void> {
    if (!this.locks.get(workspaceId)) return;
    this.abortSignals.set(workspaceId, true);
  }

  async run(workspaceId: string, taskDescription: string): Promise<OrchestratorResult> {
    const workspace = await this.workspaceService.readWorkspace(workspaceId);

    if (workspace.status !== WorkspaceStatus.Onboarded) {
      throw new WorkspaceNotReadyError(workspaceId, workspace.status);
    }

    if (this.locks.get(workspaceId)) {
      throw new WorkspaceBusyError(workspaceId);
    }

    this.locks.set(workspaceId, true);
    this.abortSignals.delete(workspaceId);

    const executionId = new Date().toISOString();

    try {
      this.emitProgress({ type: 'analyzing', workspaceId, executionId, timestamp: new Date().toISOString() });
      this.states.set(workspaceId, 'analyzing');

      const taskType = this.classifyTask(taskDescription);

      this.checkAbort(workspaceId, executionId);

      this.emitProgress({ type: 'executing', workspaceId, executionId, timestamp: new Date().toISOString() });
      this.states.set(workspaceId, 'executing');

      this.runtime ??= await createRuntime();

      const agentResult = taskType === 'implementation' && this.runtime.executeFlow
        ? await this.runtime.executeFlow(workspaceId, { description: taskDescription })
        : await this.runtime.executeTask(workspaceId, { description: taskDescription });

      this.checkAbort(workspaceId, executionId);

      const fileName = `${executionId.replace(/[:.]/g, '-')}.md`;
      const historyPath = path.join(getMetadataPath(workspaceId), 'history', fileName);

      this.checkAbort(workspaceId, executionId);

      this.emitProgress({ type: 'committing', workspaceId, executionId, timestamp: new Date().toISOString() });
      this.states.set(workspaceId, 'committing');

      let executionResult: ExecutionResult | null = null;

      if (agentResult.proposedChanges.length > 0) {
        executionResult = await this.executionService.apply({
          workspaceId,
          executionId,
          proposedChanges: agentResult.proposedChanges,
          summary: agentResult.summary,
        });
      }

      try {
        await saveHistory(
          workspaceId,
          executionId,
          { description: taskDescription },
          agentResult.summary,
          agentResult.proposedChanges,
          agentResult.tokensUsed,
          executionResult ?? undefined,
        );
      } catch (err) {
        console.error('Failed to persist execution history:', err);
      }

      this.emitProgress({ type: 'done', workspaceId, executionId, timestamp: new Date().toISOString() });
      this.states.set(workspaceId, 'done');

      return {
        executionId,
        taskType,
        summary: agentResult.summary,
        proposedChanges: agentResult.proposedChanges,
        tokensUsed: agentResult.tokensUsed,
        historyPath,
        executionResult,
      };
    } catch (err) {
      if (err instanceof AbortedError) {
        throw err;
      }
      this.emitProgress({
        type: 'error',
        workspaceId,
        executionId,
        timestamp: new Date().toISOString(),
        message: err instanceof Error ? err.message : String(err),
      });
      this.states.set(workspaceId, 'error');
      throw err;
    } finally {
      this.locks.delete(workspaceId);
      this.abortSignals.delete(workspaceId);
      this.states.set(workspaceId, 'idle');
    }
  }

  private checkAbort(workspaceId: string, executionId: string): void {
    if (!this.abortSignals.get(workspaceId)) return;

    this.emitProgress({
      type: 'aborted',
      workspaceId,
      executionId,
      timestamp: new Date().toISOString(),
      message: 'Execução abortada pelo usuário.',
    });
    this.states.set(workspaceId, 'aborted');
    throw new AbortedError(workspaceId);
  }

  private emitProgress(event: OrchestratorEvent): void {
    this.emit('progress', event);
  }

  private classifyTask(description: string): TaskType {
    try {
      const lower = description.toLowerCase();
      if (ANALYSIS_KEYWORDS.some((kw) => lower.includes(kw))) return 'analysis';
      if (QUESTION_KEYWORDS.some((kw) => lower.includes(kw))) return 'question';
      return 'implementation';
    } catch {
      return 'implementation';
    }
  }
}
