import 'package:provider/provider.dart';
import '../../modules/books/domain/usecases/get_books_with_favorites_usecase.dart';
import '../rest_client/rest_client_module.dart';
import '../../modules/books/data/datasources/books_datasource_impl.dart';
import '../../modules/books/data/repositories/books_repository_impl.dart';
import '../../modules/books/presentation/controllers/home_controller.dart';
import '../../modules/books/presentation/controllers/book_details_controller.dart';
import '../../shared/favorites_manager.dart';

class AppProviders {
  /// 1. Shared providers
  /// 2. Data layer providers (DataSource, Repository)
  /// 3. Domain layer providers (UseCases)
  /// 4. Presentation layer providers (Controllers)
  static List<dynamic> get providers => [
    // Shared providers
    ChangeNotifierProvider<FavoritesManager>(
      create: (_) => FavoritesManager(),
      lazy: false,
    ),

    // Data layer providers
    Provider<BooksDataSourceImpl>(
      create: (_) => BooksDataSourceImpl(RestClientModule.restClient),
      lazy: true,
    ),
    Provider<BooksRepositoryImpl>(
      create: (context) =>
          BooksRepositoryImpl(context.read<BooksDataSourceImpl>()),
      lazy: true,
    ),

    // Domain layer providers
    Provider<GetBooksWithFavoritesUseCase>(
      create: (context) => GetBooksWithFavoritesUseCase(
        context.read<BooksRepositoryImpl>(),
        context.read<FavoritesManager>(),
      ),
      lazy: true,
    ),

    // Presentation layer providers
    ChangeNotifierProvider<HomeController>(
      create: (context) => HomeController(
        context.read<GetBooksWithFavoritesUseCase>(),
        context.read<FavoritesManager>(),
      ),
      lazy: true,
    ),
    ChangeNotifierProvider<BookDetailsController>(
      create: (context) =>
          BookDetailsController(context.read<FavoritesManager>()),
      lazy: true,
    ),
  ];

  static List<dynamic> get developmentProviders => [...providers];

  static List<dynamic> get productionProviders => [...providers];

  static List<dynamic> getProvidersForEnvironment({
    bool isDevelopment = false,
  }) {
    return isDevelopment ? developmentProviders : productionProviders;
  }
}
