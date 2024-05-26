import 'package:chat_app/auth/login_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          buttonTheme: ButtonTheme.of(context).copyWith(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          )),

      // theme: ThemeData(
        //   brightness: Brightness.light,
        // ),
        // darkTheme: ThemeData(
        // brightness: Brightness.dark,
      // ),

      // themeMode: ThemeMode.dark,
      // /* ThemeMode.system to follow system theme,
      //    ThemeMode.light for light theme,
      //    ThemeMode.dark for dark theme
      // */
      scrollBehavior: const CupertinoScrollBehavior(),
      title: "Chat app",
      navigatorKey: AppSettings.navigatorKey,
      debugShowCheckedModeBanner: false,
      home:const LoginScreen(),
    );
  }
}

class AppSettings {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
