import '../models/book_model.dart';

abstract class BooksDataSource {
  Future<List<BookModel>> getBooks();
}
