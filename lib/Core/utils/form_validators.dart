// validators.dart
import 'package:new_project/Core/helpers/app_regex.dart';

String? validateNotEmpty(String? value, {String fieldName = "الحقل"}) {
  if (value == null || value.isEmpty) {
    return '$fieldName يجب أن لا يكون فارغًا';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'البريد الإلكتروني يجب أن لا يكون فارغًا';
  } else if (!AppRegex.isEmailValid(value)) {
    return 'البريد الإلكتروني غير صالح';
  }
  return null;
}

String? validateDate(String? value) {
  if (value == null || value.isEmpty) {
    return 'تاريخ الميلاد يجب أن لا يكون فارغًا';
  }
  // يمكن إضافة تحقق من صيغة التاريخ إذا كان مطلوبًا
  return null;
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'رقم الهاتف يجب أن لا يكون فارغًا';
  }
  // يمكن إضافة تحقق من رقم الهاتف إذا كان مطلوبًا
  return null;
}
