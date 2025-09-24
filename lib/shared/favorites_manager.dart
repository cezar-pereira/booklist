import 'package:flutter/foundation.dart';
import '../modules/books/domain/entities/book_entity.dart';

class FavoritesManager extends ChangeNotifier {
  static final FavoritesManager _instance = FavoritesManager._internal();

  factory FavoritesManager() => _instance;

  FavoritesManager._internal();

  final List<BookEntity> _favoriteBooks = [];

  List<BookEntity> get favoriteBooks => List.unmodifiable(_favoriteBooks);

  bool isFavorite(String bookId) =>
      _favoriteBooks.any((book) => book.id == bookId);

  void toggleFavorite(BookEntity book) {
    final index = _favoriteBooks.indexWhere((b) => b.id == book.id);
    if (index != -1) {
      _favoriteBooks.removeAt(index);
    } else {
      _favoriteBooks.add(book.copyWith(isFavorite: true));
    }
    notifyListeners();
  }

  void clearFavorites() {
    _favoriteBooks.clear();
    notifyListeners();
  }
}
