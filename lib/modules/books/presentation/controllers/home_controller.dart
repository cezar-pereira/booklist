import 'package:flutter/foundation.dart';
import '../../domain/entities/book_entity.dart';
import '../../../../shared/favorites_manager.dart';
import '../../domain/usecases/get_books_with_favorites_usecase.dart';
import '../states/home_state.dart';

class HomeController extends ChangeNotifier {
  final GetBooksWithFavoritesUseCase _getBooksWithFavoritesUseCase;
  final FavoritesManager _favoritesManager;

  HomeController(this._getBooksWithFavoritesUseCase, this._favoritesManager) {
    _favoritesManager.addListener(_updateBooksFavorites);
  }

  HomeState _state = const HomeInitialState();
  HomeState get state => _state;

  List<BookEntity> _books = [];
  String _searchQuery = '';

  @override
  void dispose() {
    _favoritesManager.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    _updateBooksFavorites();
  }

  void _updateBooksFavorites() {
    final updatedBooks = _books.map((book) {
      final isFavorite = _favoritesManager.isFavorite(book.id);
      return book.copyWith(isFavorite: isFavorite);
    }).toList();

    if (state is HomeSuccessState) {
      _updateState(HomeSuccessState(books: updatedBooks));
      return;
    }

    if (state is HomeSearchState) {
      _updateState(
        HomeSearchState(books: updatedBooks, searchQuery: _searchQuery),
      );
      return;
    }
  }

  Future<void> loadBooks() async {
    _updateState(const HomeLoadingState());

    try {
      _books = await _getBooksWithFavoritesUseCase.call();
      _updateState(HomeSuccessState(books: _books));
    } catch (e) {
      _updateState(HomeErrorState('Erro ao carregar livros: $e'));
    }
  }

  void searchBooks(String query) {
    _searchQuery = query;
    _state = HomeSearchState(books: _books, searchQuery: query);
    _updateBooksFavorites();
  }

  void toggleFavorite(BookEntity book) {
    _favoritesManager.toggleFavorite(book);
  }

  void _updateState(HomeState newState) {
    _state = newState;
    notifyListeners();
  }
}
