import 'dart:developer' show log;

import 'package:dio/dio.dart';
import '../utils/constants.dart';
import 'dio_rest_client.dart';
import 'rest_client.dart';

class RestClientModule {
  static RestClient? _restClient;

  static RestClient get restClient {
    _restClient ??= _createRestClient();
    return _restClient!;
  }

  static RestClient _createRestClient() {
    final dio = Dio();

    dio.options.baseUrl = AppConstants.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => log(object.toString()),
      ),
    );

    return DioRestClient(dio);
  }
}
