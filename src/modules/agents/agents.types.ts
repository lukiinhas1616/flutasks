export interface AgentDefinition {
  id: string;
  name: string;
  role: string;
}

export interface AgentTask {
  description: string;
}

export interface ProposedChange {
  action: 'create' | 'edit' | 'delete';
  path: string;
  content?: string;
}

export interface AgentResult {
  summary: string;
  proposedChanges: ProposedChange[];
  tokensUsed: number;
  executionId: string;
}

export interface ContextFile {
  name: string;
  content: string;
}
