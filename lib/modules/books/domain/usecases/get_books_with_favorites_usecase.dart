import '../entities/book_entity.dart';
import '../repositories/books_repository.dart';
import '../../../../shared/favorites_manager.dart';

class GetBooksWithFavoritesUseCase {
  final BooksRepository _booksRepository;
  final FavoritesManager _favoritesManager;

  GetBooksWithFavoritesUseCase(this._booksRepository, this._favoritesManager);

  Future<List<BookEntity>> call() async {
    final books = await _booksRepository.getBooks();

    return books.map((book) {
      //if FavoritesManager persists in the database, it will be used to get the favorite books
      final isFavorite = _favoritesManager.isFavorite(book.id);
      return book.copyWith(isFavorite: isFavorite);
    }).toList();
  }
}
