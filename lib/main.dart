import 'package:flutter/material.dart';
import 'package:to_do_list_firebase/pages/home.dart';

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Сross-platform ToDo app',
    theme: ThemeData(
      primaryColor: Colors.blue,
    ),
    home: const Home(),
  ));
}
