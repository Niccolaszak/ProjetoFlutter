# Controle de Gastos

Aplicativo simples desenvolvido em Flutter para registrar e acompanhar gastos pessoais.

## Funcionalidades

- Cadastro de gastos com descrição, valor e categoria.
- Categorias disponíveis: Alimentação, Transporte, Lazer e Outros.
- Exibição do gasto total.
- Exibição do total gasto por categoria.
- Lista com os gastos mais recentes.
- Tela de histórico com filtro por categoria.
- Exclusão de gastos com confirmação.

## Tecnologias

- Flutter
- Dart
- Material Design

## Como executar

1. Mude para a pasta do projeto:

```bash
cd controle_de_gastos
```

2. Instale as dependências:

```bash
flutter pub get
```

3. Execute o projeto:

```bash
flutter run
```

## Estrutura principal

- `lib/main.dart`: arquivo inicial do aplicativo.
- `lib/pages/controle_page.dart`: tela principal de controle dos gastos.
- `lib/pages/historic_page.dart`: tela de histórico e filtros.
- `lib/models/expense.dart`: modelo de dados de um gasto.
- `lib/enums/category_type.dart`: categorias disponíveis.
- `lib/widgets/`: widgets reutilizáveis da interface.

## Observação

Os gastos são armazenados apenas em memória durante a execução do aplicativo.
