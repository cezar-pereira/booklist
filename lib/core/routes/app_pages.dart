import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../../modules/books/presentation/pages/home_page.dart';
import '../../modules/books/presentation/pages/book_details_page.dart';
import '../../modules/books/presentation/pages/favorites_page.dart';

class AppPages {
  static final Map<String, WidgetBuilder> routes = {
    AppRoutes.home: (context) => const HomePage(),
    AppRoutes.bookDetails: (context) => const BookDetailsPage(),
    AppRoutes.favorites: (context) => const FavoritesPage(),
  };
}
