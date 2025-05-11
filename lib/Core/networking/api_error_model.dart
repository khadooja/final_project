import 'package:new_project/Core/networking/api_error_handler.dart';

class ApiErrorModel {
  final String? message;
  final int? code;

  ApiErrorModel({
    required this.message,
    this.code,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    return ApiErrorModel(
      code: json['code'] ?? ResponseCode.BAD_REQUEST,
      message: json['message'] ?? ResponseMessage.DEFAULT,
    );
  }

  Map<String, dynamic> _$ApiErrorModelToJson(ApiErrorModel instance) =>
      <String, dynamic>{
        'message': instance.message,
        'code': instance.code,
      };
}
