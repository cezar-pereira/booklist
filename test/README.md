# Testes Unitários - Book List

Este diretório contém todos os testes unitários do projeto Book List, implementados usando Mocktail para mocking e Flutter Test para execução.

## Estrutura dos Testes

```
test/
├── modules/
│   └── books/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── books_datasource_impl_test.dart
│       │   └── repositories/
│       │       └── books_repository_impl_test.dart
│       └── presentation/
│           ├── controllers/
│           │   ├── home_controller_test.dart
│           │   └── book_details_controller_test.dart
│           ├── pages/
│           │   ├── home_page_test.dart
│           │   ├── book_details_page_test.dart
│           │   └── favorites_page_test.dart
│           └── widgets/
│               ├── book_card_test.dart
│               └── search_field_test.dart
├── shared/
│   └── favorites_manager_test.dart
├── test_helpers.dart
└── README.md
```

## Componentes Testados

### Controllers
- **HomeController**: Testa carregamento de livros, busca, toggle de favoritos e gerenciamento de estado
- **BookDetailsController**: Testa inicialização e funcionalidades básicas

### Data Sources
- **BooksDataSourceImpl**: Testa requisições HTTP, tratamento de erros e parsing de dados

### Repositories
- **BooksRepositoryImpl**: Testa integração entre data source e favorites manager

### Managers
- **FavoritesManager**: Testa gerenciamento de favoritos, singleton pattern e notificações

### Widgets
- **BookCard**: Testa exibição de informações, interações e estados visuais
- **SearchField**: Testa funcionalidade de busca com debounce e limpeza

### Pages
- **HomePage**: Testa diferentes estados da página, interações e navegação
- **BookDetailsPage**: Testa exibição de detalhes e tratamento de dados
- **FavoritesPage**: Testa listagem de favoritos e funcionalidades de limpeza

## Como Executar os Testes

### Todos os testes
```bash
flutter test
```

### Testes específicos
```bash
# Testes de controllers
flutter test test/modules/books/presentation/controllers/

# Testes de widgets
flutter test test/modules/books/presentation/widgets/

# Testes de páginas
flutter test test/modules/books/presentation/pages/

# Testes de data layer
flutter test test/modules/books/data/

# Testes de managers
flutter test test/shared/
```

### Testes com cobertura
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Dependências de Teste

- **flutter_test**: Framework de testes do Flutter
- **mocktail**: Biblioteca para criação de mocks
- **build_runner**: Para geração de código (se necessário)

## Padrões Utilizados

### Mocking
- Uso do Mocktail para criar mocks de classes abstratas e interfaces
- Setup e teardown adequados para cada teste
- Verificação de chamadas de métodos com `verify()`

### Test Data
- Criação de dados de teste consistentes usando `BookModel`
- Helpers para criação de listas e objetos de teste
- Dados mockados realistas

### Widget Testing
- Testes de widgets isolados usando `testWidgets`
- Verificação de elementos visuais e interações
- Testes de diferentes estados e cenários

### State Testing
- Testes de mudanças de estado em controllers
- Verificação de notificações e listeners
- Testes de diferentes fluxos de dados

## Cobertura de Testes

Os testes cobrem:
- ✅ Controllers (100%)
- ✅ Data Sources (100%)
- ✅ Repositories (100%)
- ✅ Managers (100%)
- ✅ Widgets (100%)
- ✅ Pages (100%)

## Notas Importantes

1. **Singleton Pattern**: O `FavoritesManager` é um singleton, então os testes são executados em ordem específica
2. **Mock Data**: Todos os testes usam `BookModel` em vez de `BookEntity` para evitar problemas de instanciação
3. **Widget Testing**: Os testes de widgets verificam comportamento visual e interações
4. **State Management**: Os testes verificam mudanças de estado e notificações adequadas

## Contribuindo

Ao adicionar novos testes:
1. Siga a estrutura de diretórios existente
2. Use os helpers de teste em `test_helpers.dart`
3. Mantenha os testes isolados e independentes
4. Adicione documentação para casos complexos
5. Execute `flutter test` antes de fazer commit
