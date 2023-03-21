import 'package:flutter/material.dart';
import 'package:chat_x/screens/welcome_screen.dart';
import 'package:chat_x/screens/login_screen.dart';
import 'package:chat_x/screens/registration_screen.dart';
import 'package:chat_x/screens/chat_screen.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

// Ideal time to initialize

//...
  runApp( FlashChat());
}


class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: WelcomeScreen(),
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        ChatScreen.id:(context)=>ChatScreen(),
        RegistrationScreen.id:(context)=>RegistrationScreen(),

      }
    );

  }
}