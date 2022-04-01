import 'package:flutter/material.dart';
import 'package:to_do/screens/splashScreen.dart';

main() => runApp(const ToDo());

class ToDo extends StatelessWidget {
  const ToDo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do App',
      home: SplachScreen(),
    );
  }
}
