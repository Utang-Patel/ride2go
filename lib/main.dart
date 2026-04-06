import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const Ride2GoApp());
}

class Ride2GoApp extends StatelessWidget {
  const Ride2GoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ride2go',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const RegisterScreen(),
    );
  }
}
