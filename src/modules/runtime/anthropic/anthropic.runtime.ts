import { OnboardingService } from '../../onboarding';
import { AgentService } from '../../agents';
import { OrchestrationFlow } from '../../orchestrator/orchestrator.flow';
import type { Runtime } from '../runtime.types';
import type { OnboardingResult } from '../../onboarding/onboarding.types';
import type { AgentTask, AgentResult } from '../../agents/agents.types';

export class AnthropicApiRuntime implements Runtime {
  isAvailable(): Promise<boolean> {
    return Promise.resolve(process.env.ANTHROPIC_API_KEY !== undefined);
  }

  async onboard(workspaceId: string): Promise<OnboardingResult> {
    const onboardingService = new OnboardingService();
    return onboardingService.run(workspaceId);
  }

  async executeTask(workspaceId: string, task: AgentTask): Promise<AgentResult> {
    const agentService = new AgentService();
    return agentService.run(workspaceId, task);
  }

  async executeFlow(workspaceId: string, task: AgentTask): Promise<AgentResult> {
    const flow = new OrchestrationFlow();
    return flow.run(workspaceId, task.description);
  }
}
