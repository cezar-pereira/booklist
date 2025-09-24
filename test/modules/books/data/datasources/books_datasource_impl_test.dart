import 'package:book_list/core/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:book_list/core/rest_client/rest_client.dart';
import 'package:book_list/modules/books/data/datasources/books_datasource_impl.dart';
import 'package:book_list/modules/books/data/models/book_model.dart';

class MockRestClient extends Mock implements RestClient {}

void main() {
  late BooksDataSourceImpl dataSource;
  late MockRestClient mockRestClient;

  setUp(() {
    mockRestClient = MockRestClient();
    dataSource = BooksDataSourceImpl(mockRestClient);
  });

  group('BooksDataSourceImpl', () {
    group('getBooks', () {
      test(
        'deve retornar lista de livros quando a requisição for status code 200',
        () async {
          // Arrange
          final responseData = [
            {
              'id': '1',
              'title': 'Livro 1',
              'author': 'Autor 1',
              'published': '2023',
              'publisher': 'Editora 1',
            },
            {
              'id': '2',
              'title': 'Livro 2',
              'author': 'Autor 2',
              'published': '2023',
              'publisher': 'Editora 2',
            },
          ];

          final response = Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: AppConstants.booksEndpoint),
          );

          when(
            () => mockRestClient.get(AppConstants.booksEndpoint),
          ).thenAnswer((_) async => response);

          // Act
          final result = await dataSource.getBooks();

          // Assert
          expect(result, isA<List<BookModel>>());
          expect(result.length, equals(2));

          verify(
            () => mockRestClient.get(AppConstants.booksEndpoint),
          ).called(1);
        },
      );

      test(
        'deve lançar exceção quando status code for diferente de 200',
        () async {
          // Arrange
          final response = Response(
            data: null,
            statusCode: 404,
            requestOptions: RequestOptions(path: AppConstants.booksEndpoint),
          );

          when(
            () => mockRestClient.get(any()),
          ).thenAnswer((_) async => response);

          // Act & Assert
          expect(
            () => dataSource.getBooks(),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Failed to load books: 404'),
              ),
            ),
          );
        },
      );

      test('deve lançar exceção quando ocorrer erro na requisição', () async {
        // Arrange
        when(() => mockRestClient.get(any())).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: AppConstants.booksEndpoint),
            error: 'Erro de rede',
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getBooks(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Unexpected error'),
            ),
          ),
        );
      });

      test('deve lançar exceção quando dados forem inválidos', () async {
        // Arrange
        final responseData = [
          {'id': '1', 'title': 'Livro 1'},
        ];

        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: AppConstants.booksEndpoint),
        );

        when(() => mockRestClient.get(any())).thenAnswer((_) async => response);

        // Act & Assert
        expect(
          () => dataSource.getBooks(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Unexpected error'),
            ),
          ),
        );
      });

      test('deve retornar erro quando dados forem nulos', () async {
        // Arrange
        final response = Response(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: AppConstants.booksEndpoint),
        );

        when(() => mockRestClient.get(any())).thenAnswer((_) async => response);

        // Act & Assert
        expect(
          () => dataSource.getBooks(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Unexpected error'),
            ),
          ),
        );
      });
    });
  });
}
