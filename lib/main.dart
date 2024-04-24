import 'package:dental_scanner/screens/about_us.dart';
import 'package:dental_scanner/screens/history.dart';
import 'package:dental_scanner/screens/homepage.dart';
import 'package:dental_scanner/screens/privacy_policy.dart';
import 'package:dental_scanner/screens/services.dart';
import 'package:dental_scanner/screens/term_condition.dart';
import 'package:dental_scanner/screens/user_auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBrY-SvGyoB7fNFPJZ48PCliyK70xbXktk",
            authDomain: "dental-scanner-7fd76.firebaseapp.com",
            projectId: "dental-scanner-7fd76",
            storageBucket: "dental-scanner-7fd76.appspot.com",
            messagingSenderId: "1077288669503",
            appId: "1:1077288669503:web:f8fef28d6100cce20ec38a",
            measurementId: "G-Q1ECGGDVY7"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DENTAL X-RAY SCANNER',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.black,
          secondary: const Color.fromARGB(255, 255, 17, 0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey;
                }
                return const Color.fromARGB(255, 255, 17, 0);
              },
            ),
          ),
        ),
      ),
      home: AuthPage(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/services': (context) => ServicesScreen(),
        '/history': (context) => HistoryScreen(),
        '/about': (context) => AboutUsScreen(),
         '/policy': (context) => PrivacyPolicyScreen(),
          '/terms': (context) => TermsConditionScreen(),
      },
    );
  }
}
