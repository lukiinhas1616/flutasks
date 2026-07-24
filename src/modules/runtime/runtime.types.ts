import type { OnboardingResult } from '../onboarding/onboarding.types';
import type { AgentTask, AgentResult } from '../agents/agents.types';

export interface Runtime {
  isAvailable(): Promise<boolean>;
  onboard(workspaceId: string): Promise<OnboardingResult>;
  executeTask(workspaceId: string, task: AgentTask): Promise<AgentResult>;
  executeFlow?(workspaceId: string, task: AgentTask): Promise<AgentResult>;
}

export enum RuntimeType {
  ClaudeCode = 'claude-code',
  AnthropicApi = 'anthropic-api',
}
