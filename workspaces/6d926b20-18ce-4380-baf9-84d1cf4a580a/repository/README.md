# Flutasks

Aplicativo mobile de gerenciamento de tarefas construído com Flutter. Permite criar, listar, pesquisar, marcar como concluída e excluir tarefas, com persistência local via Hive.

---

## Tecnologias

| Camada | Tecnologia |
|---|---|
| UI | Flutter 3.x / Material Design |
| Estado | Bloc + flutter_bloc |
| Injeção de Dependência / Roteamento | flutter_modular |
| Persistência local | Hive |
| Programação funcional | dartz (Either) |
| Igualdade de entidades | equatable |
| Internacionalização | flutter_localizations + intl |

---

## Pré-requisitos

- Flutter SDK `^3.5.4` (Dart `^3.5.4`)
- Android SDK 35 com Java OpenJDK 17 (para builds Android)
- Xcode + CocoaPods (para builds iOS)

Verifique o ambiente:

```bash
flutter doctor
```

---

## Instalação

```bash
git clone <url-do-repositorio>
cd flutasks
flutter pub get
```

---

## Como rodar

```bash
# Dispositivo/emulador conectado
flutter run

# Plataforma específica
flutter run -d android
flutter run -d ios
```

---

## Estrutura do Projeto

```
lib/
├── main.dart                  # Entry point — inicializa o ModularApp
├── modules/
│   ├── app_module.dart        # Módulo raiz — registra serviços globais e sub-módulos
│   ├── app_widget.dart        # Widget raiz da aplicação
│   ├── coordinator/           # Módulo de coordenação (splash + inicialização do storage)
│   │   ├── coordinator_module.dart
│   │   ├── domain/
│   │   ├── infra/
│   │   └── presentation/
│   └── task/                  # Módulo principal — CRUD de tarefas
│       ├── task_module.dart
│       ├── domain/
│       │   ├── entities/      # TaskEntity
│       │   ├── parameters/    # DTOs de entrada por caso de uso
│       │   ├── repositories/  # Contratos (interfaces)
│       │   └── usecases/      # Casos de uso: create, delete, get, search, toggle
│       ├── infra/
│       │   ├── datasources/   # Contrato + implementação local (Hive)
│       │   ├── dtos/          # TaskResponseDto — serialização/deserialização
│       │   └── repositories/  # Implementação concreta do repositório
│       └── presentation/
│           ├── controller/    # TaskBloc, eventos e estados
│           └── ui/            # Pages, widgets e bottom sheets
└── core/
    ├── shared/                # Código compartilhado entre módulos
    │   ├── domain/
    │   │   ├── services/      # LocalStorageService (contrato)
    │   │   └── usecases/      # AsyncUsecase (base genérica)
    │   ├── infra/
    │   │   └── services/      # LocalStorageServiceImp (Hive)
    │   └── presentation/
    │       ├── controller/    # AppState base (idle, loading, error)
    │       └── ui/widgets/    # AppBar, BottomBar e Button globais
    └── utils/
        ├── app_routes/        # Rotas por módulo (CoordinatorModuleRoutes, TaskModuleRoutes)
        ├── assets_dir/        # Referências tipadas a assets (ImagesDir)
        ├── debouncer/         # Utilitário de debounce para busca
        ├── failure/           # Classe Failure — abstração de erros de domínio
        ├── mocks/             # Dados fictícios para desenvolvimento
        └── themes/            # Tema global (GlobalTheme)
```

---

## Arquitetura

O projeto segue **Clean Architecture** com separação em três camadas por módulo:

```
domain/   →  entidades, casos de uso, contratos de repositório
infra/    →  implementações concretas (datasources, repositórios, DTOs)
presentation/ →  UI, widgets, Bloc (eventos + estados)
```

**Fluxo de dados:**

```
UI (Page/Widget)
  └─► TaskBloc (Event)
        └─► UseCase
              └─► Repository (contrato)
                    └─► DataSource (Hive)
```

Erros são propagados via `Either<Failure, T>` (dartz), evitando exceções cruas na camada de apresentação.

---

## Módulo Task — Casos de Uso

| Caso de Uso | Descrição |
|---|---|
| `CreateTaskUseCase` | Cria uma nova tarefa e persiste localmente |
| `GetTasksUseCase` | Retorna todas as tarefas |
| `SearchTaskUseCase` | Filtra tarefas pelo título |
| `ToggleTaskStatusUseCase` | Alterna o status concluído/pendente |
| `DeleteTaskUseCase` | Remove uma tarefa pelo ID |
| `DeleteAllTasksUseCase` | Remove todas as tarefas |

---

## Persistência

Todas as tarefas são salvas localmente via **Hive**, encapsulado pelo `LocalStorageService`. Os dados são serializados como JSON e armazenados em uma única chave `'tasks'`.

Não há backend ou banco de dados remoto — o app funciona completamente offline.

---

## Assets

```
assets/
├── images/    # Imagens e ícone do launcher
└── fonts/     # Família tipográfica Poppins (Regular, Bold, ExtraBold, Light, Medium, SemiBold, Thin)
```

Referências a imagens são feitas via `ImagesDir` (`lib/core/utils/assets_dir/`).

---

## Gerar ícone do launcher

```bash
flutter pub run flutter_launcher_icons
```

---

## Convenções

- Arquivos: `snake_case`
- Classes: `PascalCase`; sufixos `Bloc`, `Cubit`, `Module`, `UseCase`, `Repository`, `Dto`
- Funções e variáveis: `camelCase`
- Imports: absolutos a partir de `package:flutasks/`
- Comentários: somente quando o **motivo** não é óbvio pelo código
- Abstrações prematuras são evitadas — preferir clareza a reuso forçado
