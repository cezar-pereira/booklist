import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'app_pages.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (context) => AppPages.routes[AppRoutes.home]!(context),
          settings: settings,
        );
      case AppRoutes.bookDetails:
        return MaterialPageRoute(
          builder: (context) =>
              AppPages.routes[AppRoutes.bookDetails]!(context),
          settings: settings,
        );
      case AppRoutes.favorites:
        return MaterialPageRoute(
          builder: (context) => AppPages.routes[AppRoutes.favorites]!(context),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Página não encontrada')),
          ),
          settings: settings,
        );
    }
  }
}
