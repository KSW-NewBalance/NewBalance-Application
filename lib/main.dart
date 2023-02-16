import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newbalance_flutter/result_page.dart';

import 'main_page.dart';
import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'New Balance',
      theme: ThemeData(
        primaryColor: Color(primaryColor.hashCode),
        textTheme: GoogleFonts.notoSansTextTheme()
      ),
      home: ResultPage(title: 'Main Page'),
    );
  }
}