import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:doctor/Core/services/storage_service.dart';
import 'package:doctor/Data/model/user_model.dart';

class AuthService {
  static const String _baseUrl = 'https://adixonclinicos.info/api';

  // ── Helpers ──────────────────────────────────────────────────────────────

  static Map<String, String> get _jsonHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  static Future<Map<String, String>> get _authHeaders async {
    final token = await StorageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Map<String, dynamic> _decode(http.Response res) =>
      jsonDecode(res.body) as Map<String, dynamic>;

  // ── #1 Register ──────────────────────────────────────────────────────────

  /// Returns the message string on success.
  /// Throws [AuthException] on error.
  static Future<String> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String role, // 'Doctor' or 'Staff'
    String? phone,
    String platform = 'android',
    String deviceType = 'mobile',
  }) async {
    final res = await http
        .post(
          Uri.parse('$_baseUrl/auth/register'),
          headers: _jsonHeaders,
          body: jsonEncode({
            'first_name': firstName,
            'last_name': lastName,
            'email': email,
            'password': password,
            'role': role,
            if (phone != null && phone.isNotEmpty) 'phone': phone,
            'platform': platform,
            'device_type': deviceType,
          }),
        )
        .timeout(const Duration(seconds: 15));

    final body = _decode(res);
    if (body['status'] == true) {
      return body['message'] as String;
    }
    throw AuthException(body['message'] ?? 'Registration failed', res.statusCode);
  }

  // ── #2 Login ─────────────────────────────────────────────────────────────

  /// Returns [UserModel] and saves tokens to storage on success.
  static Future<UserModel> login({
    required String email,
    required String password,
    String platform = 'android',
    String deviceType = 'mobile',
  }) async {
    final res = await http
        .post(
          Uri.parse('$_baseUrl/auth/login'),
          headers: _jsonHeaders,
          body: jsonEncode({
            'email': email,
            'password': password,
            'platform': platform,
            'device_type': deviceType,
          }),
        )
        .timeout(const Duration(seconds: 15));

    final body = _decode(res);
    if (body['status'] == true) {
      final data = body['data'] as Map<String, dynamic>;
      final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      await StorageService.saveTokens(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );
      await StorageService.saveUser(user);
      return user;
    }
    throw AuthException(body['message'] ?? 'Login failed', res.statusCode);
  }

  // ── #3 Forgot Password ───────────────────────────────────────────────────

  static Future<String> forgotPassword(String email) async {
    final res = await http
        .post(
          Uri.parse('$_baseUrl/auth/forgot-password'),
          headers: _jsonHeaders,
          body: jsonEncode({'email': email}),
        )
        .timeout(const Duration(seconds: 15));

    final body = _decode(res);
    if (body['status'] == true) return body['message'] as String;
    throw AuthException(body['message'] ?? 'Failed to send OTP', res.statusCode);
  }

  // ── #4 Verify OTP ────────────────────────────────────────────────────────

  static Future<String> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final res = await http
        .post(
          Uri.parse('$_baseUrl/auth/verify-otp'),
          headers: _jsonHeaders,
          body: jsonEncode({'email': email, 'otp': otp}),
        )
        .timeout(const Duration(seconds: 15));

    final body = _decode(res);
    if (body['status'] == true) return body['message'] as String;
    throw AuthException(body['message'] ?? 'Invalid or expired OTP', res.statusCode);
  }

  // ── #5 Reset Password ────────────────────────────────────────────────────

  static Future<String> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final res = await http
        .post(
          Uri.parse('$_baseUrl/auth/reset-password'),
          headers: _jsonHeaders,
          body: jsonEncode({'email': email, 'new_password': newPassword}),
        )
        .timeout(const Duration(seconds: 15));

    final body = _decode(res);
    if (body['status'] == true) return body['message'] as String;
    throw AuthException(body['message'] ?? 'Failed to reset password', res.statusCode);
  }

  // ── #7 Logout ─────────────────────────────────────────────────────────────

  static Future<void> logout() async {
    try {
      final headers = await _authHeaders;
      await http
          .post(Uri.parse('$_baseUrl/auth/logout'), headers: headers)
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      // Always clear locally even if API call fails
    } finally {
      await StorageService.clearAll();
    }
  }
}

// ── AuthException ─────────────────────────────────────────────────────────

class AuthException implements Exception {
  final String message;
  final int? statusCode;

  const AuthException(this.message, [this.statusCode]);

  @override
  String toString() => message;

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isConflict => statusCode == 409;
  bool get isNotFound => statusCode == 404;
}
