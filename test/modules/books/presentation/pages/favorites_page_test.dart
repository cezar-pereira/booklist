import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:book_list/modules/books/presentation/pages/favorites_page.dart';
import 'package:book_list/shared/favorites_manager.dart';
import '../../../../test_helpers.dart';

void main() {
  group('FavoritesPage', () {
    late MockFavoritesManager mockFavoritesManager;

    setUp(() {
      mockFavoritesManager = MockFavoritesManager();
      MockSetup.setupFallbackValues();
    });

    Widget createFavoritesPage() {
      return MaterialApp(
        home: ChangeNotifierProvider<FavoritesManager>(
          create: (_) => mockFavoritesManager,
          child: const FavoritesPage(),
        ),
      );
    }

    group('Estado Vazio', () {
      testWidgets('deve apresentar _EmptyState quando não há favoritos', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(() => mockFavoritesManager.favoriteBooks).thenReturn([]);

        // Act
        await tester.pumpWidget(createFavoritesPage());

        // Assert
        expect(find.text('Nenhum livro favoritado'), findsOneWidget);
        expect(
          find.text('Adicione livros aos favoritos para vê-los aqui'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.favorite_border), findsOneWidget);
        expect(find.text('Ir para Lista de Livros'), findsOneWidget);
        expect(find.byType(ListView), findsNothing);
        expect(find.byKey(const Key('_EmptyState')), findsOneWidget);
      });
    });

    group('Estado com Favoritos', () {
      testWidgets('deve apresentar _ListFavorites quando há favoritos', (
        WidgetTester tester,
      ) async {
        // Arrange
        final books = TestData.createBookList(count: 2);
        when(() => mockFavoritesManager.favoriteBooks).thenReturn(books);

        // Act
        await tester.pumpWidget(createFavoritesPage());

        // Assert
        expect(find.byType(ListView), findsOneWidget);
        expect(find.text('Nenhum livro favoritado'), findsNothing);
        expect(
          find.text('Adicione livros aos favoritos para vê-los aqui'),
          findsNothing,
        );
        expect(find.byKey(const Key('_ListFavorites')), findsOneWidget);
      });
    });

    group('Botão de Limpar Favoritos', () {
      testWidgets(
        'deve mostrar IconButton quando controller.favoriteBooks.isNotEmpty',
        (WidgetTester tester) async {
          // Arrange
          final books = TestData.createBookList(count: 1);
          when(() => mockFavoritesManager.favoriteBooks).thenReturn(books);

          // Act
          await tester.pumpWidget(createFavoritesPage());

          // Assert

          expect(
            find.byKey(const Key('_IconButtonClearFavorites')),
            findsOneWidget,
          );

          expect(find.byIcon(Icons.clear_all), findsOneWidget);
        },
      );

      testWidgets(
        'não deve mostrar IconButton quando controller.favoriteBooks.isEmpty',
        (WidgetTester tester) async {
          // Arrange
          when(() => mockFavoritesManager.favoriteBooks).thenReturn([]);

          // Act
          await tester.pumpWidget(createFavoritesPage());

          // Assert
          expect(
            find.byKey(const Key('_IconButtonClearFavorites')),
            findsNothing,
          );
        },
      );
    });

    group('AlertDialog', () {
      testWidgets('deve mostrar AlertDialog ao clicar no botão limpar', (
        WidgetTester tester,
      ) async {
        // Arrange
        final books = TestData.createBookList(count: 1);
        when(() => mockFavoritesManager.favoriteBooks).thenReturn(books);

        await tester.pumpWidget(createFavoritesPage());

        // Act
        await tester.tap(find.byIcon(Icons.clear_all));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Limpar Favoritos'), findsOneWidget);
        expect(
          find.text(
            'Tem certeza que deseja remover todos os livros dos favoritos?',
          ),
          findsOneWidget,
        );
        expect(find.text('Cancelar'), findsOneWidget);
        expect(find.text('Limpar'), findsOneWidget);
      });

      testWidgets('deve fechar AlertDialog ao clicar em Cancelar', (
        WidgetTester tester,
      ) async {
        // Arrange
        final books = TestData.createBookList(count: 1);
        when(() => mockFavoritesManager.favoriteBooks).thenReturn(books);

        await tester.pumpWidget(createFavoritesPage());

        // Act
        await tester.tap(find.byIcon(Icons.clear_all));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Cancelar'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AlertDialog), findsNothing);
      });

      testWidgets(
        'deve chamar clearFavorites e fechar dialog ao clicar em Limpar',
        (WidgetTester tester) async {
          // Arrange
          final books = TestData.createBookList(count: 1);
          when(() => mockFavoritesManager.favoriteBooks).thenReturn(books);
          when(() => mockFavoritesManager.clearFavorites()).thenReturn(null);

          await tester.pumpWidget(createFavoritesPage());

          // Act
          await tester.tap(find.byIcon(Icons.clear_all));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Limpar'));
          await tester.pumpAndSettle();

          // Assert
          verify(() => mockFavoritesManager.clearFavorites()).called(1);
          expect(find.byType(AlertDialog), findsNothing);
        },
      );
    });
  });
}
