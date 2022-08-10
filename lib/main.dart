import 'dart:convert';

import 'package:crypto/screens/Home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(Application());
}

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'la'),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
