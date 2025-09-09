# Instruções para o Gemini CLI

## Objetivo Principal

Criar um aplicativo móvel em Flutter para rastrear cotações de moedas, com uma arquitetura robusta baseada em Clean Architecture e MVVM. A aplicação deve utilizar `http` para API, `sqflite` para persistência local, `flutter_signals` para gerenciamento de estado, o padrão `Command` para ações da UI, um padrão `Facade` para gerenciar os Use Cases, e o pacote `auto_injector` para gerenciamento de dependências.

## Nome e Tema do Aplicativo

* **Nome:** CurrencyTracker
* **Tema:** Cotação e Conversão de Moedas

## Design e Tema

O aplicativo deve ter um tema customizado, com modos claro e escuro.

### Modo Claro (Light):

* **Cores:** Uma paleta com tons de bege (`#f5f5dc`) e azul (`#a9cce3`). O texto principal em um tom escuro de azul (`#2c3e50`).

### Modo Escuro (Dark):

* **Cores:** Uma paleta invertida. O fundo deve ser um azul escuro (`#2c3e50`), e os elementos primários em um bege claro (`#f5f5dc`). O texto principal em um tom claro de bege (`#f5f5dc`) ou branco.

O tema deve ser gerenciado por um `Signal<ThemeMode>` e a UI deve reagir a essa mudança.

## Escopo de Funcionalidades

O aplicativo deverá oferecer as seguintes funcionalidades principais:

* **Listar Cotações:** Exibir as cotações mais recentes de diversas moedas em um carrossel interativo.
* **Gerenciar Favoritos:** Permitir ao usuário marcar e desmarcar moedas como favoritas usando um checkbox.
* **Conversão de Moedas:**
    * Implementar uma página dedicada à conversão de moedas em tempo real, usando a cotação mais recente obtida da API.
    * O usuário deve selecionar uma moeda de origem e uma de destino e inserir o valor a ser convertido.
* **Histórico de Cotações:**
    * Armazenar um histórico das cotações no banco de dados local (`sqflite`).
    * Permitir que o usuário visualize esse histórico mesmo em modo offline.

## Especificações do Banco de Dados SQLite

O banco de dados deve ser criado na primeira execução do aplicativo. A classe `DatabaseServiceImpl` será responsável por isso.

### Tabela `currencies`

Armazenará os dados principais de cada moeda.

**Campos:**

* `id`: INTEGER PRIMARY KEY AUTOINCREMENT
* `name`: TEXT NOT NULL
* `code`: TEXT NOT NULL
* `is_favorite`: INTEGER NOT NULL (0 para falso, 1 para verdadeiro)
* `latest_quote`: REAL NOT NULL

### Tabela `historical_quotes`

Armazenará o histórico de cotações para cada moeda.

**Campos:**

* `id`: INTEGER PRIMARY KEY AUTOINCREMENT
* `currency_code`: TEXT NOT NULL (Chave estrangeira para `currencies.code`)
* `quote_value`: REAL NOT NULL
* `timestamp`: INTEGER NOT NULL (para armazenar a data em milissegundos)

### Operações de Banco de Dados (`i_database_service.dart`)

A interface do serviço de banco de dados deve incluir métodos básicos para:

* `insertCurrency(CurrencyDto dto)`
* `updateCurrency(CurrencyDto dto)`
* `deleteCurrency(String code)`
* `getCurrencies()`
* `getHistoricalQuotes(String currencyCode)`
* `insertHistoricalQuote(HistoricalQuoteDto dto)`

## Arquitetura (Clean Architecture & MVVM)

O projeto deve ser estruturado nas seguintes camadas:

### Camada de Apresentação (MVVM):

* **Views:** Os widgets e pages da UI. A página inicial (`HomePage`) deve ser um `StatefulWidget` para gerenciar o estado de carregamento inicial.
* **ViewModels:** Classes que gerenciam o estado via `signals` e interagem com o `UseCaseFacade` através dos `Commands`. A reatividade deve ser automatizada com `Effects` e `Computed`.

### Camada de Domínio:

* **Facade:** Uma classe `CurrencyUseCaseFacade` que centraliza e expõe os use cases.
* **Use Cases:** Classes que contêm as regras de negócio.
* **Entidades:** Representação de negócio pura.
* **Interfaces de Repositório:** Contratos para a camada de Dados.

### Camada de Dados:

* **Implementações de Repositório e Data Sources:** Responsáveis por obter dados e converter DTOs para entidades.

## Padrões de Design Centralizados (core)

Os padrões genéricos de arquitetura e as classes de suporte devem ser centralizados em `lib/core/` para reuso.

* **Padrão Result:** Uma abstração genérica para `Result` em `lib/core/patterns/result.dart`. `Commands`, `Use Cases`, `Repositories` e `Services` devem retornar `Future<Result<...>>`.
* **Padrão Command:** A interface base `ICommand` e classes base para comandos em `lib/core/patterns/command.dart`.

## Fluxo de Funcionamento

1.  **Carregamento Inicial:**
    * A `HomePage` (`StatefulWidget`) chama o `load_currencies_command.dart` no método `initState`.
2.  **Disparo do Command:**
    * O `LoadCurrenciesCommand` é executado, recebendo o `CurrencyUseCaseFacade` em seu construtor.
3.  **Execução do Facade:**
    * O `Command` chama o método correspondente no `CurrencyUseCaseFacade`, por exemplo, `getLatestQuotes()`.
4.  **Execução do Use Case:**
    * O `Facade` delega a chamada para o `get_latest_quotes_usecase.dart`. O use case contém a lógica de negócio para decidir se deve buscar os dados na API ou no cache local.
5.  **Comunicação com o Repositório:**
    * O `Use Case` chama a interface do repositório (`ICurrencyRepository`).
6.  **Busca e Tratamento de Dados:**
    * O `CurrencyRepositoryImpl` obtém os dados das fontes de dados (Data Sources). Ele é responsável por:
        * Chamar a API via `i_currency_remote_data_source.dart`.
        * Converter o DTO recebido (`currency_dto.dart`) em uma entidade de domínio (`currency.dart`).
        * Em caso de falha da API, tentar buscar os dados no banco de dados local via `i_currency_local_data_source.dart`.
        * Em caso de sucesso ou falha, o repositório retorna um `Future<Result<...>>`.
7.  **Propagação do Resultado:**
    * O `Result` (`Success` ou `Failure`) retorna pela cadeia de chamadas: Repository -> Use Case -> Facade -> Command.
8.  **Atualização da ViewModel:**
    * O `Command` recebe o `Result` e atualiza os `signals` na `ViewModel` com os dados ou a falha.
9.  **Reatividade da UI:**
    * A `View` (página) observa os `signals` do `ViewModel`. Quando os `signals` são alterados, a UI é automaticamente reconstruída para refletir o novo estado.

## Estrutura do Projeto

Organizar o projeto de forma modular para refletir a arquitetura:

```
lib/
├── main.dart
├── di/
│   └── injector.dart
├── core/
│   ├── api/
│   │   └── api_config.dart
│   ├── constants/
│   │   └── app_constants.dart
│   ├── failures/
│   │   └── failure.dart
│   ├── messages/
│   │   └── app_messages.dart
│   ├── patterns/
│   │   ├── command.dart
│   │   └── result.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── theme_service.dart
│   └── validation/
│       └── validator.dart
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   │   ├── i_currency_local_data_source.dart
│   │   │   └── currency_local_data_source_impl.dart
│   │   └── remote/
│   │       ├── i_currency_remote_data_source.dart
│   │       └── currency_remote_data_source_impl.dart
│   ├── database/
│   │   ├── i_database_service.dart
│   │   └── database_service_impl.dart
│   ├── dtos/
│   │   └── currency_dto.dart
│   └── repositories/
│       ├── i_currency_repository.dart
│       └── currency_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── currency.dart
│   ├── facades/
│   │   ├── i_currency_use_case_facade.dart
│   │   └── currency_use_case_facade_impl.dart
│   ├── repositories/
│   │   └── i_currency_repository.dart
│   └── usecases/
│       ├── i_usecase.dart
│       ├── get_latest_quotes_usecase.dart
│       ├── add_favorite_currency_usecase.dart
│       └── get_historical_quotes_usecase.dart
└── presentation/
    ├── pages/
    │   ├── currency_list_page.dart
    │   └── currency_converter_page.dart
    ├── viewmodels/
    │   ├── currency_list_viewmodel.dart
    │   └── currency_converter_viewmodel.dart
    ├── commands/
    │   ├── load_currencies_command.dart
    │   ├── add_favorite_command.dart
    │   └── convert_currency_command.dart
    ├── state/
    │   ├── currency_state.dart
    │   └── currency_signals.dart
    └── widgets/
        ├── currency_card.dart
        ├── currency_carousel.dart
        └── currency_carousel_item.dart
```

## Dependências (`pubspec.yaml`)

Incluir as seguintes dependências:

```yaml
dependencies:
  http:
  sqflite:
  path_provider:
  signals:
  signals_flutter:
  equatable:
  auto_injector:
  carousel_slider:
```




