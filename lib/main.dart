import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userapp/provider/auth_provider.dart';

import 'core/route/app_route.dart';
import 'core/route/app_route_name.dart';
import 'core/theme/app_theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp(
    verificationId: '',
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required String verificationId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "On Boarding With Lottie",
        theme: AppTheme.light,
        themeMode: ThemeMode.light,
        initialRoute: AppRouteName.getStarted,
        onGenerateRoute: Approute.generate,
      ),
    );
  }
}
