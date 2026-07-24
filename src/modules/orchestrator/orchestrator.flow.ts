import { AgentService } from '../agents/agents.service';
import { PM_AGENT, DEV_SPECIALIST_AGENT, TECHLEAD_AGENT } from '../agents/agents.definitions';
import type { AgentResult } from '../agents/agents.types';

export class OrchestrationFlow {
  private readonly agentService: AgentService;

  constructor() {
    this.agentService = new AgentService();
  }

  async run(workspaceId: string, taskDescription: string): Promise<AgentResult> {
    const executionId = new Date().toISOString();

    const pmResult = await this.agentService.run(
      workspaceId,
      { description: taskDescription },
      PM_AGENT,
      true,
    );

    const devResult = await this.agentService.run(
      workspaceId,
      { description: this.buildDevTask(taskDescription, pmResult.summary) },
      DEV_SPECIALIST_AGENT,
      true,
    );

    const techResult = await this.agentService.run(
      workspaceId,
      { description: this.buildTechLeadTask(taskDescription, pmResult.summary, devResult) },
      TECHLEAD_AGENT,
      true,
    );

    return {
      summary: techResult.summary,
      proposedChanges: techResult.proposedChanges,
      tokensUsed: pmResult.tokensUsed + devResult.tokensUsed + techResult.tokensUsed,
      executionId,
    };
  }

  private buildDevTask(originalTask: string, pmSummary: string): string {
    return [
      '## Tarefa Original',
      originalTask,
      '## Requisitos e Critérios de Aceitação (PM)',
      pmSummary,
      '---',
      'Implemente a tarefa com base nos requisitos acima, seguindo as convenções do projeto.',
    ].join('\n\n');
  }

  private buildTechLeadTask(
    originalTask: string,
    pmSummary: string,
    devResult: AgentResult,
  ): string {
    const changesList = devResult.proposedChanges
      .map((c) => `- ${c.action}: ${c.path}`)
      .join('\n');

    return [
      '## Tarefa Original',
      originalTask,
      '## Requisitos e Critérios de Aceitação (PM)',
      pmSummary,
      '## Implementação Proposta (Dev Specialist)',
      devResult.summary,
      changesList ? `Arquivos:\n${changesList}` : '',
      '---',
      'Revise a implementação acima. Se estiver correta e atender todos os critérios de aceitação, reproduza as mudanças propostas. Se precisar de correções, forneça a versão corrigida.',
    ]
      .filter(Boolean)
      .join('\n\n');
  }
}
