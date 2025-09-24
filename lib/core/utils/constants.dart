class AppConstants {
  static const String baseUrl =
      'https://681d018ff74de1d219ae8534.mockapi.io/api/v1';
  static const String booksEndpoint = '/books';

  static const Duration debounceDuration = Duration(milliseconds: 500);
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
