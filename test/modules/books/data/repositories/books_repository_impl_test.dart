import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:book_list/modules/books/data/datasources/books_datasource.dart';
import 'package:book_list/modules/books/data/models/book_model.dart';
import 'package:book_list/modules/books/data/repositories/books_repository_impl.dart';

class MockBooksDataSource extends Mock implements BooksDataSource {}

void main() {
  late BooksRepositoryImpl repository;
  late MockBooksDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockBooksDataSource();
    repository = BooksRepositoryImpl(mockDataSource);
  });

  group('BooksRepositoryImpl', () {
    group('getBooks', () {
      test('deve lançar exceção quando datasource falhar', () async {
        // Arrange
        when(
          () => mockDataSource.getBooks(),
        ).thenThrow(Exception('Erro de rede'));

        // Act & Assert
        expect(
          () => repository.getBooks(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to get books'),
            ),
          ),
        );

        verify(() => mockDataSource.getBooks()).called(1);
      });

      test('deve preservar propriedades originais dos livros', () async {
        // Arrange
        final bookModels = [
          BookModel(
            id: '1',
            title: 'Livro Teste',
            author: 'Autor Teste',
            published: '2023',
            publisher: 'Editora Teste',
          ),
        ];

        when(
          () => mockDataSource.getBooks(),
        ).thenAnswer((_) async => bookModels);

        // Act
        final result = await repository.getBooks();

        // Assert
        final book = result.first;
        expect(book.id, equals('1'));
        expect(book.title, equals('Livro Teste'));
        expect(book.author, equals('Autor Teste'));
        expect(book.published, equals('2023'));
        expect(book.publisher, equals('Editora Teste'));
      });
    });
  });
}
