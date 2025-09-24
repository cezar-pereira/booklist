import 'package:equatable/equatable.dart';
import '../../domain/entities/book_entity.dart';

class BookModel extends BookEntity with EquatableMixin {
  BookModel({
    required super.id,
    required super.title,
    required super.author,
    required super.published,
    required super.publisher,
    super.isFavorite,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      published: json['published'],
      publisher: json['publisher'],
    );
  }

  @override
  BookEntity copyWith({bool? isFavorite}) {
    return BookModel(
      id: id,
      title: title,
      author: author,
      published: published,
      publisher: publisher,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    author,
    published,
    publisher,
    isFavorite,
  ];
}
