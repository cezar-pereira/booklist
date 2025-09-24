import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/book_entity.dart';
import '../controllers/book_details_controller.dart';

class BookDetailsPage extends StatefulWidget {
  const BookDetailsPage({super.key});

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  BookEntity? book;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    book = ModalRoute.of(context)?.settings.arguments as BookEntity?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Livro')),
      body: Consumer<BookDetailsController>(
        builder: (context, controller, child) {
          if (book == null) {
            return const Center(child: Text('Livro não encontrado'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                book?.title ?? '',
                                style: context.textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          context,
                          'Autor',
                          book?.author ?? '',
                          Icons.person,
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          context,
                          'Data de Publicação',
                          book?.published ?? '',
                          Icons.calendar_today,
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          context,
                          'Editora',
                          book?.publisher ?? '',
                          Icons.business,
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          context,
                          'Status',
                          book?.isFavorite ?? false
                              ? 'Favoritado'
                              : 'Não favoritado',
                          book?.isFavorite ?? false
                              ? Icons.favorite
                              : Icons.favorite_border,
                          valueColor: book?.isFavorite ?? false
                              ? Colors.red
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: context.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: valueColor ?? context.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
