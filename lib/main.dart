import 'package:school/routes.dart';
import 'package:school/screens/splash_screen/splash_screen.dart';
import 'package:school/theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, device) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'School',
        theme: CustomTheme().baseTheme,
        //mean first screen
        initialRoute: SplashScreen.routeName,
        routes: routes,
      );
    });
  }
}
