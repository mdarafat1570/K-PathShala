import 'package:flutter/material.dart';
import 'package:kpathshala/view/profile_page/profile_edit.dart';

Future<dynamic> slideNavigationPush(Widget page, BuildContext context, { 
  String? widgetName,
}) async {
  return Navigator.push(context, PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  ));
}


Future<dynamic> slideNavigationPop(
    Widget page,
    BuildContext context, {required Profile Function(dynamic context) builder}
    ) {
  Navigator.pop(context);
  return _navigate(context, page);
}

Future<dynamic> slideNavigationPushAndRemoveUntil(
    Widget page,
    BuildContext context, {
      String? widgetName,
    }) async {
  return Navigator.pushAndRemoveUntil(
    context,
    _buildPageRoute(page, widgetName),
        (Route<dynamic> route) => false,
  );
}

Future<dynamic> slideNavigationPushReplacement(
    Widget page,
    BuildContext context, {
      String? widgetName,
    }) async {

  return Navigator.pushReplacement(
    context,
    _buildPageRoute(page, widgetName),
  );
}

PageRouteBuilder<dynamic> _buildPageRoute(
    Widget page,
    String? widgetName,
    ) {
  return PageRouteBuilder(
    settings: RouteSettings(name: widgetName),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

Future<dynamic> _navigate(
    BuildContext context,
    Widget page, [
      String? widgetName,
    ]) {
  return Navigator.push(
    context,
    _buildPageRoute(page, widgetName),
  );
}
