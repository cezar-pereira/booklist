import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/favorites_manager.dart';

import '../widgets/book_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesManager>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Favoritos'),
            actions: [
              if (controller.favoriteBooks.isNotEmpty)
                IconButton(
                  key: const Key('_IconButtonClearFavorites'),
                  onPressed: () =>
                      _showClearFavoritesDialog(context, controller),
                  icon: const Icon(Icons.clear_all),
                  tooltip: 'Limpar todos os favoritos',
                ),
            ],
          ),

          body: controller.favoriteBooks.isEmpty
              ? _EmptyState()
              : _ListFavorites(controller: controller),
        );
      },
    );
  }

  void _showClearFavoritesDialog(
    BuildContext context,
    FavoritesManager controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Favoritos'),
        content: const Text(
          'Tem certeza que deseja remover todos os livros dos favoritos?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              controller.clearFavorites();
              Navigator.pop(context);
              context.showSnackBar('Todos os favoritos foram removidos');
            },
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }
}

class _ListFavorites extends StatelessWidget {
  const _ListFavorites({required this.controller});
  final FavoritesManager controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const Key('_ListFavorites'),
      itemCount: controller.favoriteBooks.length,
      itemBuilder: (context, index) {
        final book = controller.favoriteBooks[index];
        return BookCard(
          book: book,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.bookDetails,
              arguments: book,
            );
          },
          onFavoriteTap: () {
            controller.toggleFavorite(book);
          },
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('_EmptyState'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: context.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum livro favoritado',
            style: context.textTheme.headlineSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Adicione livros aos favoritos para vê-los aqui',
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              );
            },
            icon: const Icon(Icons.home),
            label: const Text('Ir para Lista de Livros'),
          ),
        ],
      ),
    );
  }
}
