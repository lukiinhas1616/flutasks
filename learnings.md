# Aprendizados e Regras de Execução

- [2026-07-25T03:05:19.319Z] Before applying changes, always check if the fix was already committed in a prior execution by reading the current file state — the task history may show the same correction multiple times even when it was already applied.
- [2026-07-25T03:17:35.251Z] Agent personas for the workspace project must be defined as .claude/agents/<name>.md sub-agent files, not as TypeScript constants in src/modules/agents/. TypeScript AgentDefinition objects used by the platform's orchestration pipeline belong inline in the module that uses them (e.g., orchestrator.flow.ts), not in a separate definitions file.
