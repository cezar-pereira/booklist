import '../../../../core/rest_client/rest_client.dart';
import '../../../../core/utils/constants.dart';
import '../models/book_model.dart';
import 'books_datasource.dart';

class BooksDataSourceImpl implements BooksDataSource {
  final RestClient _restClient;

  BooksDataSourceImpl(this._restClient);

  @override
  Future<List<BookModel>> getBooks() async {
    try {
      final response = await _restClient.get(AppConstants.booksEndpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => BookModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
