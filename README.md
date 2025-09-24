# 📚 BookList - Aplicativo de Lista de Livros

Um aplicativo Flutter para gerenciar uma lista de livros com funcionalidades de busca, favoritos e detalhes completos.

## 🚀 Funcionalidades

### 📖 **Gerenciamento de Livros**
- **Lista de livros** com carregamento dinâmico
- **Busca em tempo real** por título do livro
- **Detalhes completos** de cada livro (título, autor, data de publicação, editora)
- **Sistema de favoritos** com persistência em memória
- **Estados de carregamento** e tratamento de erros


### 🔍 **Funcionalidades de Busca**
- **Busca instantânea** conforme o usuário digita
- **Mensagens informativas** quando não há resultados

### ❤️ **Sistema de Favoritos**
- **Adicionar/remover** livros dos favoritos
- **Tela dedicada** para visualizar favoritos
- **Persistência local** dos favoritos
- **Limpeza em lote** dos favoritos

## 🛠️ Tecnologias Utilizadas

### **Flutter & Dart**
- **Flutter:** 3.35.1
- **Dart:** 3.9.0
- **SDK:** ^3.9.0

### **Dependências Principais**
```yaml
dependencies:
  flutter: sdk
  cupertino_icons: ^1.0.8      # Ícones iOS
  dio: ^5.9.0                  # Cliente HTTP
  provider: ^6.1.5+1           # Prover dependências
  equatable: ^2.0.7            # Comparação de objetos (facilitando testes e regras de negócio)
  mocktail: ^1.0.4             # Mocking para testes
```


## 🏗️ Arquitetura

O projeto segue os princípios da **Clean Architecture** com separação clara de responsabilidades:

### **📁 Estrutura de Pastas**
```
lib/
├── core/                       # Funcionalidades centrais
│   ├── providers/             # Providers globais
│   ├── rest_client/           # Cliente HTTP (Dio)
│   ├── routes/                # Configuração de rotas
│   ├── theme/                 # Temas da aplicação
│   └── utils/                 # Utilitários e extensões
├── modules/books/             # Módulo de livros
│   ├── data/                  # Camada de dados
│   │   ├── datasources/       # Fontes de dados (API, Local)
│   │   ├── models/            # Modelos de dados
│   │   └── repositories/      # Implementação dos repositórios
│   ├── domain/                # Camada de domínio
│   │   ├── entities/          # Entidades de negócio
│   │   ├── repositories/      # Contratos dos repositórios
│   │   └── usecases/          # Casos de uso
│   └── presentation/          # Camada de apresentação
│       ├── controllers/       # Controladores (ViewModel)
│       ├── pages/             # Telas da aplicação
│       ├── states/            # Estados da aplicação
│       └── widgets/           # Componentes reutilizáveis
└── shared/                    # Recursos compartilhados
```


## 🚀 Como Executar o Projeto

### **Pré-requisitos**
- Flutter 3.35.1 ou superior
- Dart 3.9.0 ou superior
- Android Studio / VS Code com extensão Flutter
- Emulador Android ou dispositivo físico

### **1. Clone o Repositório**
```bash
git clone https://github.com/cezar-pereira/booklist.git
cd book_list
```

### **2. Instale as Dependências**
```bash
flutter pub get
```

### **3. Execute o Projeto**
```bash
# Para desenvolvimento
flutter run

# Para modo release
flutter run --release

# Para um dispositivo específico
flutter run -d <device-id>
```

### **4. Executar Testes**
```bash
# Todos os testes
flutter test
```

## 📱 Telas da Aplicação

### **🏠 HomePage**
- Lista principal de livros
- Campo de busca
- Botão de acesso aos favoritos
- Estados: Loading, Success, Error, Search

### **📖 BookDetailsPage**
- Detalhes completos do livro
- Informações: Título, Autor, Data, Editora, Status

### **❤️ FavoritesPage**
- Lista de livros favoritados
- Opção de limpar todos os favoritos
- Confirmação antes de limpar

## 🧪 Testes

O projeto possui **cobertura completa de testes** com:

### **📊 Cobertura de Testes**
- **Testes de Widget** - Interface e interações
- **Testes de Controller** - Lógica de negócio
- **Testes de Repository** - Camada de dados
- **Testes de Use Cases** - Regras de negócio
- **Testes de Integração** - Fluxos completos

### **🔧 Ferramentas de Teste**
- **Mocktail** - Mocking de dependências
- **Flutter Test** - Framework de testes
- **Widget Tester** - Testes de interface
