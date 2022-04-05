import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:to_do/screens/home.dart';
import 'package:to_do/shared/constants.dart';

class SplachScreen extends StatelessWidget {
  const SplachScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: Home(),
      imageSrc: 'assets/images/splashScreenIcon.png',
      imageSize: 60,
      duration: 6000,
      text: "To Do App",
      textType: TextType.TyperAnimatedText,
      textStyle: const TextStyle(
        fontSize: 40.0,
        fontFamily: 'PermanentMarker',
        fontWeight: FontWeight.w900,
        color: mainTextColor,
      ),
      backgroundColor: const Color(0xFF232323),
    );
  }
}
