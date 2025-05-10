// lib/helper/navigation_extension.dart

import 'package:flutter/widgets.dart';

extension Navigation on BuildContext {
  // تنقل إلى شاشة جديدة باستخدام pushNamed
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  // تنقل إلى شاشة جديدة مع استبدال الشاشة الحالية باستخدام pushReplacementNamed
  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  // تنقل إلى شاشة جديدة مع إزالة الشاشات السابقة باستخدام pushNamedAndRemoveUntil
  Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {Object? arguments, required RoutePredicate predicate}) {
    return Navigator.of(this)
        .pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  // رجوع للشاشة السابقة
  void pop() => Navigator.of(this).pop();
}
