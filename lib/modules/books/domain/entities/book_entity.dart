abstract class BookEntity {
  final String id;
  final String title;
  final String author;
  final String published;
  final String publisher;
  final bool isFavorite;

  const BookEntity({
    required this.id,
    required this.title,
    required this.author,
    required this.published,
    required this.publisher,
    this.isFavorite = false,
  });

  BookEntity copyWith({bool? isFavorite});
}
