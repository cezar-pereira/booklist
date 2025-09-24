import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:book_list/modules/books/presentation/pages/home_page.dart';
import 'package:book_list/modules/books/presentation/controllers/home_controller.dart';
import 'package:book_list/modules/books/presentation/states/home_state.dart';
import '../../../../test_helpers.dart';

class MockHomeController extends Mock implements HomeController {}

void main() {
  group('HomePage', () {
    late MockHomeController mockHomeController;

    setUp(() {
      mockHomeController = MockHomeController();
      MockSetup.setupFallbackValues();
    });

    Widget createHomePage() {
      return MaterialApp(
        home: ChangeNotifierProvider<HomeController>(
          create: (_) => mockHomeController,
          child: const HomePage(),
        ),
      );
    }

    group('Estados da HomePage', () {
      testWidgets('deve exibir HomeInitialState corretamente', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(
          () => mockHomeController.state,
        ).thenReturn(const HomeInitialState());
        when(() => mockHomeController.loadBooks()).thenAnswer((_) async {});
        when(() => mockHomeController.searchBooks(any())).thenReturn(null);
        when(() => mockHomeController.toggleFavorite(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createHomePage());

        // Assert
        expect(find.byKey(const Key('HomeInitialState')), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byKey(const Key('HomeLoadingState')), findsNothing);
        expect(find.byKey(const Key('HomeErrorState')), findsNothing);
        expect(find.byKey(const Key('HomeSuccessState_Empty')), findsNothing);
        expect(find.byKey(const Key('HomeSuccessState_List')), findsNothing);
        expect(find.byKey(const Key('HomeSearchState_Empty')), findsNothing);
        expect(find.byKey(const Key('HomeSearchState_List')), findsNothing);
      });

      testWidgets('deve exibir HomeLoadingState corretamente', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(
          () => mockHomeController.state,
        ).thenReturn(const HomeLoadingState());
        when(() => mockHomeController.loadBooks()).thenAnswer((_) async {});
        when(() => mockHomeController.searchBooks(any())).thenReturn(null);
        when(() => mockHomeController.toggleFavorite(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createHomePage());

        // Assert
        expect(find.byKey(const Key('HomeLoadingState')), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byKey(const Key('HomeInitialState')), findsNothing);
        expect(find.byKey(const Key('HomeErrorState')), findsNothing);
        expect(find.byKey(const Key('HomeSuccessState_Empty')), findsNothing);
        expect(find.byKey(const Key('HomeSuccessState_List')), findsNothing);
        expect(find.byKey(const Key('HomeSearchState_Empty')), findsNothing);
        expect(find.byKey(const Key('HomeSearchState_List')), findsNothing);
      });

      testWidgets('deve exibir HomeErrorState corretamente', (
        WidgetTester tester,
      ) async {
        // Arrange
        const errorMessage = 'Erro ao carregar livros';
        when(
          () => mockHomeController.state,
        ).thenReturn(const HomeErrorState(errorMessage));
        when(() => mockHomeController.loadBooks()).thenAnswer((_) async {});
        when(() => mockHomeController.searchBooks(any())).thenReturn(null);
        when(() => mockHomeController.toggleFavorite(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createHomePage());

        // Assert
        expect(find.byKey(const Key('HomeErrorState')), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);
        expect(find.byKey(const Key('HomeInitialState')), findsNothing);
        expect(find.byKey(const Key('HomeLoadingState')), findsNothing);
        expect(find.byKey(const Key('HomeSuccessState_Empty')), findsNothing);
        expect(find.byKey(const Key('HomeSuccessState_List')), findsNothing);
        expect(find.byKey(const Key('HomeSearchState_Empty')), findsNothing);
        expect(find.byKey(const Key('HomeSearchState_List')), findsNothing);
      });

      testWidgets('deve exibir HomeSuccessState com lista vazia corretamente', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(
          () => mockHomeController.state,
        ).thenReturn(const HomeSuccessState(books: []));
        when(() => mockHomeController.loadBooks()).thenAnswer((_) async {});
        when(() => mockHomeController.searchBooks(any())).thenReturn(null);
        when(() => mockHomeController.toggleFavorite(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createHomePage());

        // Assert
        expect(find.byKey(const Key('HomeSuccessState_Empty')), findsOneWidget);
        expect(find.text('Nenhum livro encontrado'), findsOneWidget);
        expect(find.byKey(const Key('HomeInitialState')), findsNothing);
        expect(find.byKey(const Key('HomeLoadingState')), findsNothing);
        expect(find.byKey(const Key('HomeErrorState')), findsNothing);
        expect(find.byKey(const Key('HomeSuccessState_List')), findsNothing);
        expect(find.byKey(const Key('HomeSearchState_Empty')), findsNothing);
        expect(find.byKey(const Key('HomeSearchState_List')), findsNothing);
      });

      testWidgets(
        'deve exibir HomeSuccessState com lista de livros corretamente',
        (WidgetTester tester) async {
          // Arrange
          final books = TestData.createBookList(count: 2);
          when(
            () => mockHomeController.state,
          ).thenReturn(HomeSuccessState(books: books));
          when(() => mockHomeController.loadBooks()).thenAnswer((_) async {});
          when(() => mockHomeController.searchBooks(any())).thenReturn(null);
          when(() => mockHomeController.toggleFavorite(any())).thenReturn(null);

          // Act
          await tester.pumpWidget(createHomePage());

          // Assert
          expect(
            find.byKey(const Key('HomeSuccessState_List')),
            findsOneWidget,
          );
          expect(find.byType(ListView), findsOneWidget);
          expect(find.byKey(const Key('HomeInitialState')), findsNothing);
          expect(find.byKey(const Key('HomeLoadingState')), findsNothing);
          expect(find.byKey(const Key('HomeErrorState')), findsNothing);
          expect(find.byKey(const Key('HomeSuccessState_Empty')), findsNothing);
          expect(find.byKey(const Key('HomeSearchState_Empty')), findsNothing);
          expect(find.byKey(const Key('HomeSearchState_List')), findsNothing);
        },
      );

      testWidgets('deve exibir HomeSearchState com lista vazia corretamente', (
        WidgetTester tester,
      ) async {
        // Arrange
        const searchQuery = 'teste';
        when(() => mockHomeController.state).thenReturn(
          const HomeSearchState(books: [], searchQuery: searchQuery),
        );
        when(() => mockHomeController.loadBooks()).thenAnswer((_) async {});
        when(() => mockHomeController.searchBooks(any())).thenReturn(null);
        when(() => mockHomeController.toggleFavorite(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createHomePage());

        // Assert
        expect(find.byKey(const Key('HomeSearchState_Empty')), findsOneWidget);
        expect(
          find.text('Nenhum livro encontrado para $searchQuery'),
          findsOneWidget,
        );
        expect(find.byKey(const Key('HomeInitialState')), findsNothing);
        expect(find.byKey(const Key('HomeLoadingState')), findsNothing);
        expect(find.byKey(const Key('HomeErrorState')), findsNothing);
        expect(find.byKey(const Key('HomeSuccessState_Empty')), findsNothing);
        expect(find.byKey(const Key('HomeSuccessState_List')), findsNothing);
        expect(find.byKey(const Key('HomeSearchState_List')), findsNothing);
      });

      testWidgets(
        'deve exibir HomeSearchState com lista de livros corretamente',
        (WidgetTester tester) async {
          // Arrange
          final books = TestData.createBookList(count: 2);
          // Usar um searchQuery que corresponda aos títulos dos livros de teste
          const searchQuery = 'Livro';
          when(
            () => mockHomeController.state,
          ).thenReturn(HomeSearchState(books: books, searchQuery: searchQuery));
          when(() => mockHomeController.loadBooks()).thenAnswer((_) async {});
          when(() => mockHomeController.searchBooks(any())).thenReturn(null);
          when(() => mockHomeController.toggleFavorite(any())).thenReturn(null);

          // Act
          await tester.pumpWidget(createHomePage());

          // Assert
          expect(find.byKey(const Key('HomeSearchState_List')), findsOneWidget);
          expect(find.byType(ListView), findsOneWidget);
          expect(find.byKey(const Key('HomeInitialState')), findsNothing);
          expect(find.byKey(const Key('HomeLoadingState')), findsNothing);
          expect(find.byKey(const Key('HomeErrorState')), findsNothing);
          expect(find.byKey(const Key('HomeSuccessState_Empty')), findsNothing);
          expect(find.byKey(const Key('HomeSuccessState_List')), findsNothing);
          expect(find.byKey(const Key('HomeSearchState_Empty')), findsNothing);
        },
      );
    });

    group('Elementos da Interface', () {
      testWidgets('deve exibir AppBar com título e botão de favoritos', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(
          () => mockHomeController.state,
        ).thenReturn(const HomeLoadingState());
        when(() => mockHomeController.loadBooks()).thenAnswer((_) async {});
        when(() => mockHomeController.searchBooks(any())).thenReturn(null);
        when(() => mockHomeController.toggleFavorite(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createHomePage());

        // Assert
        expect(find.text('Lista de Livros'), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('deve exibir SearchField', (WidgetTester tester) async {
        // Arrange
        when(
          () => mockHomeController.state,
        ).thenReturn(const HomeLoadingState());
        when(() => mockHomeController.loadBooks()).thenAnswer((_) async {});
        when(() => mockHomeController.searchBooks(any())).thenReturn(null);
        when(() => mockHomeController.toggleFavorite(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createHomePage());

        // Assert
        expect(find.byType(TextField), findsOneWidget);
      });
    });
  });
}
