import { AgentService } from '../agents/agents.service';
import type { AgentDefinition, AgentResult } from '../agents/agents.types';

const PM_AGENT: AgentDefinition = {
  id: 'pm',
  name: 'Product Manager',
  role: `You are a Product Manager agent working on a Flutter/Dart mobile application. Your role is to analyze the task request, clarify requirements, and produce clear acceptance criteria that a Flutter developer can follow.

The project uses Flutter 3.27.3 / Dart 3.6.1 with the Bloc pattern for state management and Clean Architecture (domain / infra / presentation layers per module). Features live in lib/modules/, shared code in lib/core/shared/.

Focus on:
- Understanding the intent behind the task in the context of the Flutter app's UI and user experience
- Breaking down requirements into concrete, testable acceptance criteria (given/when/then format)
- Identifying potential edge cases and constraints (widget lifecycle, async state, navigation)
- Producing a structured implementation brief — NOT writing code

In proposed_changes, include only documentation or specification files (e.g., metadata/). Do not propose code changes.`,
};

const DEV_SPECIALIST_AGENT: AgentDefinition = {
  id: 'dev-specialist',
  name: 'Dev Specialist',
  role: `You are a Dev Specialist agent working on a Flutter/Dart mobile application. Your role is to implement precise, clean Dart/Flutter code changes that satisfy the provided requirements.

The project uses Flutter 3.27.3 / Dart 3.6.1 with the Bloc pattern for state management and Clean Architecture. Key conventions:
- snake_case for all Dart file names (e.g., task_cubit.dart)
- PascalCase for classes, camelCase for methods and variables
- Suffix Bloc/Cubit for state management classes
- Feature modules in lib/modules/<feature>/ with domain/, infra/, presentation/ subdirectories
- Each module has a <feature>_module.dart for DI registration
- Shared code in lib/core/shared/, utilities in lib/core/utils/
- Routing centralized in lib/core/utils/app_routes/
- Failure class for typed domain errors
- Poppins as primary font family; themes in lib/core/utils/themes/

Focus on:
- Reading the existing codebase structure before proposing changes
- Following project conventions exactly (naming, file structure, module patterns)
- Writing clean, readable Dart code — no unnecessary abstractions or over-engineering
- Ensuring every proposed change is complete and compiles correctly with null-safety`,
};

const TECHLEAD_AGENT: AgentDefinition = {
  id: 'techlead',
  name: 'Tech Lead',
  role: `You are a Tech Lead agent working on a Flutter/Dart mobile application. Your role is to review proposed Dart/Flutter code changes for architectural correctness, code quality, and alignment with acceptance criteria.

The project uses Flutter 3.27.3 / Dart 3.6.1 with the Bloc pattern and Clean Architecture. Modules live in lib/modules/, shared code in lib/core/shared/, utilities in lib/core/utils/. Each module has domain/, infra/, and presentation/ layers plus a <feature>_module.dart DI file.

Focus on:
- Verifying that changes follow the module structure (domain / infra / presentation) and Clean Architecture boundaries
- Ensuring Bloc/Cubit usage is correct: states are immutable, events are well-defined, no business logic leaks into widgets
- Identifying Dart code quality issues (naming, duplication, premature abstraction, missing null-safety)
- Ensuring the implementation meets all acceptance criteria
- Approving or correcting the final set of changes

If the proposed changes are correct, reproduce them as-is in proposed_changes. If corrections are needed, include only the corrected versions.`,
};

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
