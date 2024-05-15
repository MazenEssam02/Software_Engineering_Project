import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:expenso/pages/Splash.dart';
import 'package:expenso/providers/UserProvider.dart';
import 'package:expenso/theme/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    // systemNavigationBarColor: Colors.transparent
  ));

  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyDx0KkzhvrqVZHw3wdfypVOzNBOxNZNCJ8',
    appId: '1:1044912973644:android:7d48c026565613369591e9',
    messagingSenderId: '1044912973644',
    projectId: 'expnseo',
    storageBucket: 'expnseo.appspot.com',
  ));
  await FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onBackgroundMessage(
    (message) async {
      print(message.notification?.title);
      print(message.notification?.body);
      print(message.data);
    },
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'expenso',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: const MaterialColor(0xFF2C3137, {
              50: const Color(0xFF2C3137),
              100: const Color(0xFF2C3137),
              200: const Color(0xFF2C3137),
              300: const Color(0xFF2C3137),
              400: const Color(0xFF2C3137),
              500: const Color(0xFF2C3137),
              600: const Color(0xFF2C3137),
              700: const Color(0xFF2C3137),
              800: const Color(0xFF2C3137),
              900: const Color(0xFF2C3137)
            }),
            appBarTheme:
                const AppBarTheme(backgroundColor: white, elevation: 0),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            backgroundColor: white),
        home: SplashScreen(),
      ),
    );
  }
}
