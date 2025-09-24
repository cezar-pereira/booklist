import '../entities/book_entity.dart';

abstract class BooksRepository {
  Future<List<BookEntity>> getBooks();
}
