# Convenções de Código

## Nomenclatura de Arquivos
- snake_case para todos os arquivos Dart (ex: `app_module.dart`, `coordinator_module.dart`)
- Arquivos de módulo nomeados como `<feature>_module.dart`
- Diretórios de utilitários nomeados em snake_case descritivo (ex: `app_routes/`, `assets_dir/`, `debouncer/`)

## Nomenclatura de Classes e Funções
- PascalCase para classes (ex: `AppModule`, `AppWidget`)
- camelCase para funções, métodos e variáveis
- Sufixo `Module` para classes de registro de módulo
- Sufixo `Bloc` ou `Cubit` para classes de gerenciamento de estado (padrão Bloc)

## Tratamento de Erros
- Uso de classe `Failure` centralizada em `lib/core/utils/failure/` para representar erros de domínio
- Erros propagados via Either/Result pattern (convenção Clean Architecture com Bloc)

## Estilo de Importações
- Importações absolutas a partir de `lib/` (package imports)
- Separação implícita entre imports do SDK, pacotes externos e arquivos internos

## Outras Convenções Observadas
- Assets declarados em `pubspec.yaml` e referenciados via utilitário `assets_dir/`
- Fontes Poppins como família tipográfica principal; Quicksand e SF Pro Text como secundárias
- Temas centralizados em `lib/core/utils/themes/`
- Mocks isolados em `lib/core/utils/mocks/` (separação clara de dados fictícios)
- Roteamento centralizado em `lib/core/utils/app_routes/`
