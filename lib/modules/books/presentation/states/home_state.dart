import '../../domain/entities/book_entity.dart';

sealed class HomeState {
  const HomeState();
}

class HomeInitialState extends HomeState {
  const HomeInitialState();
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState();
}

class HomeErrorState extends HomeState {
  const HomeErrorState(this.error);
  final String error;
}

class HomeSuccessState extends HomeState {
  final List<BookEntity> books;

  const HomeSuccessState({required this.books});
}

class HomeSearchState extends HomeState {
  final List<BookEntity> _books;
  final String searchQuery;

  const HomeSearchState({
    required List<BookEntity> books,
    required this.searchQuery,
  }) : _books = books;

  List<BookEntity> get books => _books.where((book) {
    return book.title.toLowerCase().contains(searchQuery.toLowerCase());
  }).toList();
}
