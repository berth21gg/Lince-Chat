import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lince_chat/firebase_options.dart';
import 'package:lince_chat/pages/home.dart';
import 'package:lince_chat/pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lince Chat',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        appBarTheme:
            const AppBarTheme(elevation: 0, backgroundColor: Colors.green),
        useMaterial3: true,
        fontFamily: GoogleFonts.ibmPlexSans().fontFamily,
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? const Login()
          : const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
