import 'package:chat_x/screens/login_screen.dart';
import 'package:chat_x/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_x/round_button.dart';


class WelcomeScreen extends StatefulWidget {


 static const String  id='welcome_screen';

  const WelcomeScreen({super.key});
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 1),
            vsync: this,
        );

    animation=
        ColorTween(begin: Colors.blueGrey,end: Colors.white).animate(controller);

    controller.forward();

    controller.addListener(() {
      setState(() {
      });

    });

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor:animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
              Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 100.0,
                  ),
                ),

        AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Flash Chat',
              textStyle: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
              speed: const Duration(milliseconds: 200),
            ),
          ],
        ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundButton(
              title: 'Log In',
              colour: Colors.lightBlueAccent,
              onPressed:() {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundButton(
              title: 'Register',
              colour: Colors.blueAccent,
              onPressed:() {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}



