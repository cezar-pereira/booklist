import 'package:flutter_test/flutter_test.dart';
import 'package:book_list/shared/favorites_manager.dart';
import 'package:book_list/modules/books/data/models/book_model.dart';

void main() {
  late FavoritesManager favoritesManager;

  setUp(() {
    favoritesManager = FavoritesManager();
    favoritesManager.clearFavorites(); // Limpa favoritos antes de cada teste
  });

  group('FavoritesManager', () {
    group('Singleton', () {
      test('deve retornar a mesma instância', () {
        final instance1 = FavoritesManager();
        final instance2 = FavoritesManager();
        expect(instance1, same(instance2));
      });
    });

    group('favoriteBooks', () {
      test('deve retornar lista vazia inicialmente', () {
        expect(favoritesManager.favoriteBooks, isEmpty);
      });

      test('deve retornar lista imutável', () {
        final books = favoritesManager.favoriteBooks;
        expect(
          () => books.add(
            BookModel(
              id: '1',
              title: 'Test',
              author: 'Test',
              published: '2023',
              publisher: 'Test',
            ),
          ),
          throwsUnsupportedError,
        );
      });
    });

    group('isFavorite', () {
      test('deve retornar false para livro não favoritado', () {
        final book = BookModel(
          id: '1',
          title: 'Livro 1',
          author: 'Autor 1',
          published: '2023',
          publisher: 'Editora 1',
        );

        expect(favoritesManager.isFavorite(book.id), isFalse);
      });

      test('deve retornar true para livro favoritado', () {
        final book = BookModel(
          id: '1',
          title: 'Livro 1',
          author: 'Autor 1',
          published: '2023',
          publisher: 'Editora 1',
        );

        favoritesManager.toggleFavorite(book);
        expect(favoritesManager.isFavorite(book.id), isTrue);
      });
    });

    group('toggleFavorite', () {
      test(
        'deve adicionar livro aos favoritos quando não estiver favoritado',
        () {
          final book = BookModel(
            id: '1',
            title: 'Livro 1',
            author: 'Autor 1',
            published: '2023',
            publisher: 'Editora 1',
          );

          favoritesManager.toggleFavorite(book);

          expect(favoritesManager.favoriteBooks.length, equals(1));
          expect(favoritesManager.favoriteBooks.first.id, equals('1'));
          expect(favoritesManager.favoriteBooks.first.isFavorite, isTrue);
        },
      );

      test('deve remover livro dos favoritos quando já estiver favoritado', () {
        final book = BookModel(
          id: '1',
          title: 'Livro 1',
          author: 'Autor 1',
          published: '2023',
          publisher: 'Editora 1',
        );

        // Adiciona o livro
        favoritesManager.toggleFavorite(book);
        expect(favoritesManager.favoriteBooks.length, equals(1));

        // Remove o livro
        favoritesManager.toggleFavorite(book);
        expect(favoritesManager.favoriteBooks.length, equals(0));
      });

      test('deve notificar listeners quando adicionar favorito', () {
        bool listenerCalled = false;
        favoritesManager.addListener(() {
          listenerCalled = true;
        });

        final book = BookModel(
          id: '1',
          title: 'Livro 1',
          author: 'Autor 1',
          published: '2023',
          publisher: 'Editora 1',
        );

        favoritesManager.toggleFavorite(book);

        expect(listenerCalled, isTrue);
      });

      test('deve notificar listeners quando remover favorito', () {
        final book = BookModel(
          id: '1',
          title: 'Livro 1',
          author: 'Autor 1',
          published: '2023',
          publisher: 'Editora 1',
        );

        // Adiciona o livro primeiro
        favoritesManager.toggleFavorite(book);

        bool listenerCalled = false;
        favoritesManager.addListener(() {
          listenerCalled = true;
        });

        // Remove o livro
        favoritesManager.toggleFavorite(book);

        expect(listenerCalled, isTrue);
      });

      test('deve manter isFavorite como true ao adicionar favorito', () {
        final book = BookModel(
          id: '1',
          title: 'Livro 1',
          author: 'Autor 1',
          published: '2023',
          publisher: 'Editora 1',
          isFavorite: false,
        );

        favoritesManager.toggleFavorite(book);

        final favoriteBook = favoritesManager.favoriteBooks.first;
        expect(favoriteBook.isFavorite, isTrue);
      });
    });

    group('clearFavorites', () {
      test('deve limpar todos os favoritos', () {
        final book1 = BookModel(
          id: '1',
          title: 'Livro 1',
          author: 'Autor 1',
          published: '2023',
          publisher: 'Editora 1',
        );

        final book2 = BookModel(
          id: '2',
          title: 'Livro 2',
          author: 'Autor 2',
          published: '2023',
          publisher: 'Editora 2',
        );

        favoritesManager.toggleFavorite(book1);
        favoritesManager.toggleFavorite(book2);

        expect(favoritesManager.favoriteBooks.length, equals(2));

        favoritesManager.clearFavorites();

        expect(favoritesManager.favoriteBooks.length, equals(0));
      });

      test('deve notificar listeners ao limpar favoritos', () {
        final book = BookModel(
          id: '1',
          title: 'Livro 1',
          author: 'Autor 1',
          published: '2023',
          publisher: 'Editora 1',
        );

        favoritesManager.toggleFavorite(book);

        bool listenerCalled = false;
        favoritesManager.addListener(() {
          listenerCalled = true;
        });

        favoritesManager.clearFavorites();

        expect(listenerCalled, isTrue);
      });
    });

    group('múltiplos livros', () {
      test('deve gerenciar múltiplos livros favoritos', () {
        final book1 = BookModel(
          id: '1',
          title: 'Livro 1',
          author: 'Autor 1',
          published: '2023',
          publisher: 'Editora 1',
        );

        final book2 = BookModel(
          id: '2',
          title: 'Livro 2',
          author: 'Autor 2',
          published: '2023',
          publisher: 'Editora 2',
        );

        final book3 = BookModel(
          id: '3',
          title: 'Livro 3',
          author: 'Autor 3',
          published: '2023',
          publisher: 'Editora 3',
        );

        favoritesManager.toggleFavorite(book1);
        favoritesManager.toggleFavorite(book2);
        favoritesManager.toggleFavorite(book3);

        expect(favoritesManager.favoriteBooks.length, equals(3));
        expect(favoritesManager.isFavorite('1'), isTrue);
        expect(favoritesManager.isFavorite('2'), isTrue);
        expect(favoritesManager.isFavorite('3'), isTrue);

        // Remove um livro
        favoritesManager.toggleFavorite(book2);

        expect(favoritesManager.favoriteBooks.length, equals(2));
        expect(favoritesManager.isFavorite('1'), isTrue);
        expect(favoritesManager.isFavorite('2'), isFalse);
        expect(favoritesManager.isFavorite('3'), isTrue);
      });
    });
  });
}
