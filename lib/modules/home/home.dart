import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Home Page",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}
