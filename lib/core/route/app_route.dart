import 'package:flutter/material.dart';
import '../../screens/getstarted_screen.dart';
import 'app_route_name.dart';

class Approute {
  static Route<dynamic>? generate(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteName.getStarted:
        return MaterialPageRoute(
          builder: (_) => const GetStartedscreen(),
          settings: settings,
        );
    }
    return null;
  }
}
