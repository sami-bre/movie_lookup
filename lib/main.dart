import 'package:flutter/material.dart';

import 'start_page.dart';
import 'search_results_page.dart';
import 'detail_page.dart';

const String api_key = '68d94cd4257c407195ec66ebe5b749f7';
final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(
    MaterialApp(
      // this key below allows me to get a reference to the ScaffoldMessenger
      // which in turn allows me to show a SnackBar.
      scaffoldMessengerKey: scaffoldKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      routes: {
        '/': (context) => HomePage(),
        '/detail': (context) => DetailPage(),
      },
    ),
  );
}
