import 'package:flutter/material.dart';
import 'package:menafn/views/homepage.dart';
import 'package:flutter_automation/flutter_automation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MENAFN App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: HomePage(),
        routes: {});
  }
}
