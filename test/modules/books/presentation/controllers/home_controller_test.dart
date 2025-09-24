import 'package:book_list/modules/books/domain/usecases/get_books_with_favorites_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:book_list/modules/books/data/models/book_model.dart';
import 'package:book_list/modules/books/domain/repositories/books_repository.dart';
import 'package:book_list/modules/books/presentation/controllers/home_controller.dart';
import 'package:book_list/modules/books/presentation/states/home_state.dart';
import 'package:book_list/shared/favorites_manager.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

class MockFavoritesManager extends Mock implements FavoritesManager {}

void main() {
  late HomeController controller;
  late MockBooksRepository mockRepository;
  late FavoritesManager favoritesManager;
  late GetBooksWithFavoritesUseCase getBooksWithFavoritesUseCase;

  setUp(() {
    mockRepository = MockBooksRepository();
    favoritesManager = FavoritesManager();
    getBooksWithFavoritesUseCase = GetBooksWithFavoritesUseCase(
      mockRepository,
      favoritesManager,
    );
    controller = HomeController(getBooksWithFavoritesUseCase, favoritesManager);
  });

  group('HomeController', () {
    test('deve inicializar com estado inicial', () {
      expect(controller.state, isA<HomeInitialState>());
    });

    group('loadBooks', () {
      test('deve carregar livros com sucesso', () async {
        // Arrange
        final books = [
          BookModel(
            id: '1',
            title: 'Livro 1',
            author: 'Autor 1',
            published: '2023',
            publisher: 'Editora 1',
          ),
          BookModel(
            id: '2',
            title: 'Livro 2',
            author: 'Autor 2',
            published: '2023',
            publisher: 'Editora 2',
          ),
        ];

        when(() => mockRepository.getBooks()).thenAnswer((_) async => books);

        // Act
        await controller.loadBooks();

        // Assert
        expect(controller.state, isA<HomeSuccessState>());
        final successState = controller.state as HomeSuccessState;
        expect(successState.books, equals(books));
        verify(() => mockRepository.getBooks()).called(1);
      });

      test('deve tratar erro ao carregar livros', () async {
        // Arrange
        when(
          () => mockRepository.getBooks(),
        ).thenThrow(Exception('Erro de rede'));

        // Act
        await controller.loadBooks();

        // Assert
        expect(controller.state, isA<HomeErrorState>());
        final errorState = controller.state as HomeErrorState;
        expect(errorState.error, contains('Erro ao carregar livros'));
      });
    });

    group('searchBooks', () {
      test('deve atualizar estado para busca com query', () {
        // Arrange
        controller.loadBooks();

        // Act
        controller.searchBooks('teste');

        // Assert
        expect(controller.state, isA<HomeSearchState>());
        final searchState = controller.state as HomeSearchState;
        expect(searchState.searchQuery, equals('teste'));
      });
    });

    group('_updateBooksFavorites', () {
      test('deve atualizar favoritos em HomeSuccessState', () async {
        // Arrange
        final books = [
          BookModel(
            id: '1',
            title: 'Livro 1',
            author: 'Autor 1',
            published: '2023',
            publisher: 'Editora 1',
          ),
        ];

        when(() => mockRepository.getBooks()).thenAnswer((_) async => books);

        // Act
        await controller.loadBooks();

        // Assert
        expect(controller.state, isA<HomeSuccessState>());
        var state = controller.state as HomeSuccessState;

        expect(state.books.first.isFavorite, isFalse);

        controller.toggleFavorite(books.first);
        state = controller.state as HomeSuccessState;

        expect(state.books.first.isFavorite, isTrue);
      });
    });

    group('dispose', () {
      test('deve remover listener do favoritesManager', () {
        // Act
        FavoritesManager mockFavoritesManager = MockFavoritesManager();
        final controller = HomeController(
          getBooksWithFavoritesUseCase,
          mockFavoritesManager,
        );

        controller.dispose();

        // Assert
        verify(() => mockFavoritesManager.removeListener(any())).called(1);
      });
    });
  });
}
