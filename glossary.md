# Glossário do Projeto

## Task
Entidade central do domínio — representa uma tarefa na lista de tarefas do usuário. Possui camadas domain, infra e presentation dentro de `lib/modules/task/`.

## Coordinator
Módulo responsável pela coordenação de fluxo entre telas/módulos da aplicação. Localizado em `lib/modules/coordinator/`.

## Module
Unidade de feature autossuficiente contendo domain, infra e presentation. Cada módulo possui um arquivo `*_module.dart` para registro e injeção de dependência.

## Core/Shared
Código reutilizável entre módulos, organizado também em domain/infra/presentation. Localizado em `lib/core/shared/`.

## Failure
Abstração de erro de domínio usada para representar falhas de forma tipada, evitando exceções cruas na camada de apresentação.

## AppRoutes
Centralização das rotas de navegação da aplicação, definidas em `lib/core/utils/app_routes/`.

## Bloc
Padrão de gerenciamento de estado adotado no projeto (Business Logic Component), separando lógica de negócio da UI.
