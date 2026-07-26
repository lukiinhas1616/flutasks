# Plano: Funcionalidades de Valor Agregado — FluTasks

**Data:** 2026-07-26  
**Status:** Pendente de implementação

---

## Contexto

Análise do projeto FluTasks identificou ausências funcionais que impactam diretamente a experiência do usuário. As funcionalidades abaixo foram priorizadas por valor percebido e esforço de implementação.

---

## Funcionalidades Identificadas (por prioridade)

### 1. Editar Tarefa *(prioridade crítica)*

**Problema:** Atualmente não existe nenhum caso de uso nem UI para editar uma tarefa existente. O usuário só pode criar ou deletar.

**Impacto:** Alta — fluxo básico de qualquer gerenciador de tarefas.

**O que implementar:**
- Caso de uso `UpdateTask` em `domain/usecases/`
- Método `update` no `ITaskRepository` e `TaskRepositoryImp`
- Evento `UpdateTask` e handler no `TaskBloc`
- Tela ou bottom sheet de edição reutilizando o formulário de criação

---

### 2. Prioridade no `TaskEntity` *(prioridade alta)*

**Problema:** `TaskEntity` não possui campo de prioridade (baixa/média/alta). Todas as tarefas têm o mesmo peso.

**Impacto:** Médio-alto — permite ao usuário distinguir urgência.

**O que implementar:**
- Adicionar campo `priority` (enum `TaskPriority`) ao `TaskEntity`
- Atualizar `TaskResponseDto` para serializar/desserializar `priority`
- Atualizar UI para exibir e selecionar prioridade

**Observação:** Esta mudança é pré-requisito para ordenação por prioridade (item 3).

---

### 3. Ordenação e Filtros no BLoC *(prioridade alta)*

**Problema:** As tarefas são exibidas sem ordem garantida. Não há filtros além de "feitas" vs "não feitas".

**Impacto:** Médio-alto — melhora a usabilidade com muitas tarefas.

**O que implementar:**
- Evento `SortTasks` no `TaskBloc` com enum `SortOrder` (por data, por prioridade, alfabético)
- Filtros adicionais: por prioridade, por data de vencimento
- Persistir preferência de ordenação no estado do BLoC

**Dependência:** Requer campo `priority` (item 2) para ordenação por prioridade.

---

### 4. Timestamps de Criação *(prioridade média)*

**Problema:** `TaskEntity` não registra quando a tarefa foi criada.

**Impacto:** Médio — permite ordenação cronológica e histórico.

**O que implementar:**
- Adicionar campo `createdAt` (`DateTime`) ao `TaskEntity`
- Atualizar `TaskResponseDto` para persistir o valor
- Exibir data de criação na listagem (opcional)

---

### 5. Data de Vencimento *(prioridade média)*

**Problema:** Não há como associar um prazo a uma tarefa.

**Impacto:** Médio — aumenta a utilidade para planejamento.

**O que implementar:**
- Adicionar campo `dueDate` (`DateTime?`) ao `TaskEntity`
- Atualizar `TaskResponseDto`
- Adicionar seletor de data na UI de criação/edição
- Exibir indicador visual quando a data estiver próxima ou vencida

**Dependência:** Idealmente implementado junto com a edição de tarefa (item 1).

---

## Ordem de Implementação Sugerida

```
1. Editar Tarefa          → valor imediato, independente
2. Timestamps de Criação  → mudança estrutural simples, sem dependências
3. Prioridade             → enriquece o modelo
4. Ordenação e Filtros    → depende de prioridade
5. Data de Vencimento     → depende de edição de tarefa
```

---

## Arquivos Impactados (estimativa)

| Arquivo | Funcionalidades que o afetam |
|---|---|
| `lib/modules/task/domain/entities/task_entity.dart` | 2, 3, 4, 5 |
| `lib/modules/task/infra/models/task_response_dto.dart` | 2, 4, 5 |
| `lib/modules/task/domain/repositories/i_task_repository.dart` | 1 |
| `lib/modules/task/infra/repositories/task_repository_imp.dart` | 1 |
| `lib/modules/task/presentation/bloc/task_bloc.dart` | 1, 3 |
| `lib/modules/task/presentation/bloc/task_event.dart` | 1, 3 |
| `lib/modules/task/presentation/bloc/task_state.dart` | 3 |
| `lib/modules/task/domain/usecases/` | 1 |
| `lib/modules/task/presentation/pages/` | 1, 2, 5 |

---

## Notas

- Nenhum pacote externo novo é necessário para os itens 1–4.
- O item 5 (data de vencimento) pode se beneficiar de um date picker, mas o Flutter já possui `showDatePicker` nativo.
- Todos os itens seguem o padrão Clean Architecture + BLoC já estabelecido no projeto.
