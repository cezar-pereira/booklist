import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:book_list/modules/books/data/models/book_model.dart';
import 'package:book_list/modules/books/domain/repositories/books_repository.dart';
import 'package:book_list/modules/books/presentation/controllers/home_controller.dart';
import 'package:book_list/modules/books/presentation/controllers/book_details_controller.dart';
import 'package:book_list/shared/favorites_manager.dart';

// Mock classes
class MockBooksRepository extends Mock implements BooksRepository {}

class MockFavoritesManager extends Mock implements FavoritesManager {}

class MockHomeController extends Mock implements HomeController {}

class MockBookDetailsController extends Mock implements BookDetailsController {}

// Test data helpers
class TestData {
  static BookModel createBook({
    String id = '1',
    String title = 'Livro Teste',
    String author = 'Autor Teste',
    String published = '2023',
    String publisher = 'Editora Teste',
    bool isFavorite = false,
  }) {
    return BookModel(
      id: id,
      title: title,
      author: author,
      published: published,
      publisher: publisher,
      isFavorite: isFavorite,
    );
  }

  static List<BookModel> createBookList({int count = 3}) {
    return List.generate(
      count,
      (index) => createBook(
        id: '${index + 1}',
        title: 'Livro ${index + 1}',
        author: 'Autor ${index + 1}',
      ),
    );
  }
}

// Widget test helpers
class TestWidgets {
  static Widget createMaterialApp({required Widget child}) {
    return MaterialApp(home: child);
  }

  static Widget createScaffold({required Widget body}) {
    return Scaffold(body: body);
  }
}

// Mock setup helpers
class MockSetup {
  static void setupFallbackValues() {
    registerFallbackValue(TestData.createBook());
  }
}
