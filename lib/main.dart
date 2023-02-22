import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newbalance_flutter/services/thingsboard_service.dart';

import 'analysis_page.dart';
import 'main_page.dart';
import 'constants.dart' as constants;

void main() {
  ThingsBoardService.performLoginInTenant();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'New Balance',
      theme: ThemeData(
        primaryColor: constants.primaryColor,
        textTheme: GoogleFonts.notoSansTextTheme()
      ),
      home: const AnalysisPage(state: 0),
    );
  }
}