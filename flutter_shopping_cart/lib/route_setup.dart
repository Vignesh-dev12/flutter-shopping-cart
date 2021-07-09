import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/ui/routes/cart/view/cart_view.dart';
import 'package:flutter_shopping_cart/ui/routes/login_and_register/view/login_view.dart';
import 'package:flutter_shopping_cart/ui/routes/login_and_register/view/register_view.dart';

abstract class RouterViews {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        case RoutePaths.CartView:
          return MaterialPageRoute(builder: (_) => CartView());

        case RoutePaths.LoginView:
          return MaterialPageRoute(builder: (_) => LoginView());

        case RoutePaths.RegisterView:
          return MaterialPageRoute(builder: (_) => RegisterView());

        default:
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            ),
          );
      }
    } catch (e) {
      print(e);
    }
  }
}

class RoutePaths {
  static const String CartView = 'cartView';
  static const String LoginView = 'loginView';
  static const String RegisterView = 'registerView';
}
