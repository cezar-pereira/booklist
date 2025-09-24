import 'package:book_list/modules/books/presentation/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/book_entity.dart';
import '../controllers/home_controller.dart';
import '../states/home_state.dart';
import '../widgets/book_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>().loadBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Livros'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.favorites);
            },
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
      body: Consumer<HomeController>(
        builder: (context, controller, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: SearchField(onChanged: controller.searchBooks),
              ),

              switch (controller.state) {
                HomeInitialState() => const Center(
                  key: Key('HomeInitialState'),
                  child: CircularProgressIndicator(),
                ),
                HomeLoadingState() => const Center(
                  key: Key('HomeLoadingState'),
                  child: CircularProgressIndicator(),
                ),
                HomeErrorState(:final error) => _OnErrorState(
                  key: const Key('HomeErrorState'),
                  error: error,
                ),
                HomeSuccessState(:final books) =>
                  books.isEmpty
                      ? _EmptyBooks(
                          key: const Key('HomeSuccessState_Empty'),
                          message: 'Nenhum livro encontrado',
                        )
                      : _ListBooks(
                          key: const Key('HomeSuccessState_List'),
                          books: books,
                          onFavoriteTap: controller.toggleFavorite,
                        ),

                HomeSearchState(:final books, :final searchQuery) =>
                  books.isEmpty
                      ? _EmptyBooks(
                          key: const Key('HomeSearchState_Empty'),
                          message: 'Nenhum livro encontrado para $searchQuery',
                        )
                      : _ListBooks(
                          key: const Key('HomeSearchState_List'),
                          books: books,
                          onFavoriteTap: controller.toggleFavorite,
                        ),
              },
            ],
          );
        },
      ),
    );
  }
}

class _EmptyBooks extends StatelessWidget {
  const _EmptyBooks({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: context.textTheme.bodyLarge?.copyWith(
        color: context.colorScheme.onSurfaceVariant,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _ListBooks extends StatelessWidget {
  const _ListBooks({
    super.key,
    required this.books,
    required this.onFavoriteTap,
  });
  final List<BookEntity> books;
  final ValueChanged<BookEntity> onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return BookCard(
            book: book,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.bookDetails,
                arguments: book,
              );
            },
            onFavoriteTap: () => onFavoriteTap(book),
          );
        },
      ),
    );
  }
}

class _OnErrorState extends StatelessWidget {
  const _OnErrorState({super.key, required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(error));
  }
}
