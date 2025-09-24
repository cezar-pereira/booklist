import '../../domain/entities/book_entity.dart';
import '../../domain/repositories/books_repository.dart';
import '../datasources/books_datasource.dart';

class BooksRepositoryImpl implements BooksRepository {
  final BooksDataSource _dataSource;
  BooksRepositoryImpl(this._dataSource);

  @override
  Future<List<BookEntity>> getBooks() async {
    try {
      final models = await _dataSource.getBooks();
      return models;
    } catch (e) {
      throw Exception('Failed to get books: $e');
    }
  }
}
