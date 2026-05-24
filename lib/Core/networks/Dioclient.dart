import 'package:dio/dio.dart';
import 'package:movies/core/constant/Apiconstant.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio client;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    client = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("📡 REQUEST → ${options.method} ${options.uri}");
          print("🧾 Headers: ${options.headers}");
          print("📦 Data: ${options.data}");
          handler.next(options);
        },
        onResponse: (response, handler) {
          print("✅ RESPONSE → ${response.statusCode}");
          print("📥 Data: ${response.data}");
          handler.next(response);
        },
        onError: (DioException e, handler) {
          print("❌ ERROR → ${e.message}");
          handler.next(e);
        },
      ),
    );
  }
}
