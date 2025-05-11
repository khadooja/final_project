import 'package:jwt_decoder/jwt_decoder.dart';

class JwtHelper {
  static Future<Map<String, dynamic>> getDecodedUserData(String token) async {
    // تأكد من إزالة كلمة Bearer إذا كانت موجودة
    if (token.startsWith("Bearer ")) {
      token = token.replaceFirst("Bearer ", "");
    }

    return JwtDecoder.decode(token);
  }
}
