// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      status: json['status'] as bool,
      statusCode: (json['status_code'] as num).toInt(),
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : LoginUserData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'status_code': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

LoginUserData _$LoginUserDataFromJson(Map<String, dynamic> json) =>
    LoginUserData(
      userCode: json['user_code'] as String?,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$LoginUserDataToJson(LoginUserData instance) =>
    <String, dynamic>{
      'user_code': instance.userCode,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'role': instance.role,
      'token': instance.token,
    };
