import 'package:dio/dio.dart';
import 'package:doctor/Core/constant/Apiconstant.dart';
import 'package:doctor/Core/networks/Dioclient.dart';

class ApiService {
  static final Dio _client = DioClient().client;
  static Future<dynamic> getAPI(
  String apiName, {
  Map<String, dynamic>? queryParams,
  String? baseUrl2,
}) async {
  try {
    final String callUrl =
        baseUrl2 != null ? baseUrl2 + apiName : ApiConstants.baseUrl + apiName;

    // _client.options.headers["User-Agent"] = "insomnia/11.2.0";

    print("📡 GET → $callUrl");
    print("🔍 Params: $queryParams");

    final response = await _client.get(
      callUrl,
      queryParameters: queryParams,
    );

    if (response.statusCode == 200) {
      return {
        "status": true,
        "statusCode": response.statusCode,
        "data": response.data,
      };
    }

    return {
      "status": false,
      "message": "Unexpected response",
      "statusCode": response.statusCode,
    };
  } on DioException catch (e) {
    return _handleDioError(e);
  }
}

static Future<dynamic> putAPI(
  String apiName,
  dynamic formData, {
  String? baseUrl2,
}) async {
  try {
    final String callUrl =
        baseUrl2 != null ? baseUrl2 + apiName : ApiConstants.baseUrl + apiName;

    // _client.options.headers["User-Agent"] = "insomnia/11.2.0";

    print("📡 PUT → $callUrl");
    print("📦 Data: $formData");

    final response = await _client.put(callUrl, data: formData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        "status": true,
        "statusCode": response.statusCode,
        "data": response.data,
      };
    }

    return {
      "status": false,
      "message": "Unexpected response",
      "statusCode": response.statusCode,
    };
  } on DioException catch (e) {
    return _handleDioError(e);
  }
}
static Future<dynamic> deleteAPI(
  String apiName, {
  dynamic formData,
  String? baseUrl2,
}) async {
  try {
    final String callUrl =
        baseUrl2 != null ? baseUrl2 + apiName : ApiConstants.baseUrl + apiName;

    // _client.options.headers["User-Agent"] = "insomnia/11.2.0";

    print("📡 DELETE → $callUrl");
    print("📦 Data: $formData");

    final response = await _client.delete(
      callUrl,
      data: formData,
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return {
        "status": true,
        "statusCode": response.statusCode,
        "data": response.data,
      };
    }

    return {
      "status": false,
      "message": "Unexpected response",
      "statusCode": response.statusCode,
    };
  } on DioException catch (e) {
    return _handleDioError(e);
  }
}


  static Future<dynamic> postAPI(
    String apiName,
    dynamic formData, {
    String? baseUrl2,
  }) async {
    try {
      // ✅ Build URL
      final String callUrl =
          baseUrl2 != null ? baseUrl2 + apiName : ApiConstants.baseUrl + apiName;

      // ✅ Headers
      // _client.options.headers["User-Agent"] = "insomnia/11.2.0";
      // _client.options.headers["token"] = ApiConstants.accessToken;

      print("------------------------------------------------------------");
      print("📡 POST API CALL");
      print("➡️ URL: $callUrl");
      print("🧾 Headers: ${_client.options.headers}");
      print("📦 Data: $formData");
      print("------------------------------------------------------------");

      final response = await _client.post(callUrl, data: formData);

      // ✅ Handle success
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "status": true,
          "statusCode": response.statusCode,
          "data": response.data,
        };
      }

      return {
        "status": false,
        "message": "Unexpected response",
        "statusCode": response.statusCode,
      };
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e, stacktrace) {
      print("⚠️ Unexpected Error: $e");
      print("🪵 Stacktrace: $stacktrace");
      return {
        "status": false,
        "message": "Something went wrong. Please try again later."
      };
    }
  }

  // ✅ CENTRAL ERROR HANDLER
  static Map<String, dynamic> _handleDioError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response?.statusCode;

      print("🔴 Server Error ($statusCode): ${e.response?.data}");

      switch (statusCode) {
        case 400:
          return {"status": false, "message": "Bad request"};
        case 401:
          return {"status": false, "message": "Unauthorized access"};
        case 403:
          return {"status": false, "message": "Access forbidden"};
        case 404:
          return {"status": false, "message": "Resource not found"};
        case 408:
          return {"status": false, "message": "Request timeout"};
        case 500:
          return {"status": false, "message": "Internal server error"};
        case 502:
        case 503:
        case 504:
          return {"status": false, "message": "Server unavailable"};
        default:
          return {
            "status": false,
            "message": "Unexpected server error ($statusCode)",
            "data": e.response?.data
          };
      }
    }

    // ✅ No response (network issue)
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return {"status": false, "message": "Connection timeout"};
      case DioExceptionType.receiveTimeout:
        return {"status": false, "message": "Response timeout"};
      case DioExceptionType.connectionError:
        return {"status": false, "message": "Network error"};
      case DioExceptionType.cancel:
        return {"status": false, "message": "Request cancelled"};
      default:
        return {
          "status": false,
          "message": e.message ?? "Unexpected error"
        };
    }
  }
}
