import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:book_list/modules/books/presentation/pages/book_details_page.dart';
import 'package:book_list/modules/books/presentation/controllers/book_details_controller.dart';
import 'package:book_list/modules/books/domain/entities/book_entity.dart';
import '../../../../test_helpers.dart';

class MockBookDetailsController extends Mock implements BookDetailsController {}

void main() {
  group('BookDetailsPage', () {
    late MockBookDetailsController mockBookDetailsController;

    setUp(() {
      mockBookDetailsController = MockBookDetailsController();
      MockSetup.setupFallbackValues();
    });

    Widget createBookDetailsPage({BookEntity? book}) {
      return MaterialApp(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<BookDetailsController>(
              create: (_) => mockBookDetailsController,
              child: const BookDetailsPage(),
            ),
            settings: RouteSettings(arguments: book),
          );
        },
      );
    }

    group('Exibição de Livro Válido', () {
      testWidgets('deve exibir todos os detalhes do livro corretamente', (
        WidgetTester tester,
      ) async {
        // Arrange
        final book = TestData.createBook(
          id: '1',
          title: 'O Senhor dos Anéis',
          author: 'J.R.R. Tolkien',
          published: '1954',
          publisher: 'Allen & Unwin',
          isFavorite: true,
        );

        // Act
        await tester.pumpWidget(createBookDetailsPage(book: book));

        // Assert
        // Verificar título
        expect(find.text('O Senhor dos Anéis'), findsOneWidget);

        // Verificar autor
        expect(find.text('Autor'), findsOneWidget);
        expect(find.text('J.R.R. Tolkien'), findsOneWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);

        // Verificar data de publicação
        expect(find.text('Data de Publicação'), findsOneWidget);
        expect(find.text('1954'), findsOneWidget);
        expect(find.byIcon(Icons.calendar_today), findsOneWidget);

        // Verificar editora
        expect(find.text('Editora'), findsOneWidget);
        expect(find.text('Allen & Unwin'), findsOneWidget);
        expect(find.byIcon(Icons.business), findsOneWidget);

        // Verificar status de favorito
        expect(find.text('Status'), findsOneWidget);
        expect(find.text('Favoritado'), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsOneWidget);
      });

      testWidgets('deve exibir livro não favoritado corretamente', (
        WidgetTester tester,
      ) async {
        // Arrange
        final book = TestData.createBook(
          id: '2',
          title: '1984',
          author: 'George Orwell',
          published: '1949',
          publisher: 'Secker & Warburg',
          isFavorite: false,
        );

        // Act
        await tester.pumpWidget(createBookDetailsPage(book: book));

        // Assert
        // Verificar título
        expect(find.text('1984'), findsOneWidget);

        // Verificar autor
        expect(find.text('George Orwell'), findsOneWidget);

        // Verificar data de publicação
        expect(find.text('1949'), findsOneWidget);

        // Verificar editora
        expect(find.text('Secker & Warburg'), findsOneWidget);

        // Verificar status de favorito
        expect(find.text('Não favoritado'), findsOneWidget);
        expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      });

      testWidgets('deve exibir AppBar com título correto', (
        WidgetTester tester,
      ) async {
        // Arrange
        final book = TestData.createBook();

        // Act
        await tester.pumpWidget(createBookDetailsPage(book: book));

        // Assert
        expect(find.text('Detalhes do Livro'), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('deve exibir Card com informações do livro', (
        WidgetTester tester,
      ) async {
        // Arrange
        final book = TestData.createBook(
          title: 'Teste Livro',
          author: 'Autor Teste',
        );

        // Act
        await tester.pumpWidget(createBookDetailsPage(book: book));

        // Assert
        expect(find.byType(Card), findsOneWidget);
        expect(find.text('Teste Livro'), findsOneWidget);
        expect(find.text('Autor Teste'), findsOneWidget);
      });
    });

    group('Exibição de Livro Inválido', () {
      testWidgets('deve exibir mensagem de erro quando livro é null', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createBookDetailsPage(book: null));

        // Assert
        expect(find.text('Livro não encontrado'), findsOneWidget);
        expect(find.byType(Card), findsNothing);
      });
    });

    group('Estrutura da Interface', () {
      testWidgets('deve ter SingleChildScrollView como container principal', (
        WidgetTester tester,
      ) async {
        // Arrange
        final book = TestData.createBook();

        // Act
        await tester.pumpWidget(createBookDetailsPage(book: book));

        // Assert
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('deve ter Column com crossAxisAlignment correto', (
        WidgetTester tester,
      ) async {
        // Arrange
        final book = TestData.createBook();

        // Act
        await tester.pumpWidget(createBookDetailsPage(book: book));

        // Assert
        final column = tester.widget<Column>(find.byType(Column).first);
        expect(column.crossAxisAlignment, CrossAxisAlignment.start);
      });

      testWidgets('deve ter padding correto no SingleChildScrollView', (
        WidgetTester tester,
      ) async {
        // Arrange
        final book = TestData.createBook();

        // Act
        await tester.pumpWidget(createBookDetailsPage(book: book));

        // Assert
        final scrollView = tester.widget<SingleChildScrollView>(
          find.byType(SingleChildScrollView),
        );
        expect(scrollView.padding, const EdgeInsets.all(16));
      });
    });

    group('Ícones e Labels', () {
      testWidgets('deve exibir todos os ícones corretos para cada campo', (
        WidgetTester tester,
      ) async {
        // Arrange
        final book = TestData.createBook(isFavorite: true);

        // Act
        await tester.pumpWidget(createBookDetailsPage(book: book));

        // Assert
        expect(find.byIcon(Icons.person), findsOneWidget);
        expect(find.byIcon(Icons.calendar_today), findsOneWidget);
        expect(find.byIcon(Icons.business), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsOneWidget);
      });

      testWidgets('deve exibir todos os labels corretos', (
        WidgetTester tester,
      ) async {
        // Arrange
        final book = TestData.createBook();

        // Act
        await tester.pumpWidget(createBookDetailsPage(book: book));

        // Assert
        expect(find.text('Autor'), findsOneWidget);
        expect(find.text('Data de Publicação'), findsOneWidget);
        expect(find.text('Editora'), findsOneWidget);
        expect(find.text('Status'), findsOneWidget);
      });
    });

    group('Cores e Estilos', () {
      testWidgets('deve aplicar cor vermelha para status favoritado', (
        WidgetTester tester,
      ) async {
        // Arrange
        final book = TestData.createBook(isFavorite: true);

        // Act
        await tester.pumpWidget(createBookDetailsPage(book: book));

        // Assert
        expect(find.text('Favoritado'), findsOneWidget);
        // Verificar se o ícone de favorito está presente
        expect(find.byIcon(Icons.favorite), findsOneWidget);
      });

      testWidgets('deve aplicar cor padrão para status não favoritado', (
        WidgetTester tester,
      ) async {
        // Arrange
        final book = TestData.createBook(isFavorite: false);

        // Act
        await tester.pumpWidget(createBookDetailsPage(book: book));

        // Assert
        expect(find.text('Não favoritado'), findsOneWidget);
        // Verificar se o ícone de favorito vazio está presente
        expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      });
    });
  });
}
