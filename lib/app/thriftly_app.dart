import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';

class ThriftlyApp extends StatelessWidget {
  const ThriftlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thriftly',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const HomeScreen(),
    );
  }
}
