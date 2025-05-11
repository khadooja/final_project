// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      token: json['token'] as String?,
      tokenType: json['tokenType'] as String?,
      userName: json['userName'] as String?,
      role: json['role'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      centerId: (json['centerId'] as num?)?.toInt(),
      message: json['message'] as String?,
      status: json['status'] as bool?,
      code: (json['code'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'tokenType': instance.tokenType,
      'userName': instance.userName,
      'role': instance.role,
      'userId': instance.userId,
      'centerId': instance.centerId,
      'message': instance.message,
      'status': instance.status,
      'code': instance.code,
    };
