// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$ForgotPasswordRequestBodyToJson(
  ForgotPasswordRequestBody instance,
) => <String, dynamic>{'email': instance.email};

Map<String, dynamic> _$VerifyOtpRequestBodyToJson(
  VerifyOtpRequestBody instance,
) => <String, dynamic>{'email': instance.email, 'otp': instance.otp};


Map<String, dynamic> _$ResetPasswordRequestBodyToJson(
  ResetPasswordRequestBody instance,
) => <String, dynamic>{
  'email': instance.email,
  'new_password': instance.newPassword,
};
