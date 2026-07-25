# Arquitetura do Projeto

## Linguagem Principal
Dart (Flutter 3.27.3 / Dart 3.6.1)

## Frameworks e Bibliotecas
- Flutter SDK
- Bloc Pattern (gerenciamento de estado)

## Estrutura de Módulos
O projeto segue Clean Architecture com separação em três camadas por módulo:
- `domain/` — entidades, casos de uso e contratos de repositório
- `infra/` — implementações concretas (repositórios, datasources)
- `presentation/` — UI, widgets, blocs/cubits

Módulos de feature ficam em `lib/modules/` (ex: `coordinator/`, `task/`), cada um com seu próprio arquivo `*_module.dart`. Código compartilhado entre módulos fica em `lib/core/shared/` com a mesma divisão domain/infra/presentation. Utilitários transversais ficam em `lib/core/utils/` (rotas, temas, assets, debouncer, failure, mocks).

## Entry Points
- `lib/main.dart` — ponto de entrada da aplicação
- `lib/modules/app_module.dart` — registro de módulos e injeção de dependência
- `lib/modules/app_widget.dart` — widget raiz da aplicação

## Ferramentas de Build
- Flutter CLI (`flutter pub get`, `flutter run`)
- Gradle (Android)
- Xcode / CocoaPods (iOS)
- Android SDK 35 / Java OpenJDK 17
