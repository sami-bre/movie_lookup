import 'package:flutter/material.dart';

import 'start_page.dart';
import 'search_results_page.dart';
import 'detail_page.dart';
import 'about_page.dart';

const String api_key = 'a5d01b4d751380e044e2246e605df108';
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
        '/': (context) => StartPage(),
        '/searchResult': (context) => SearchResultPage(),
        '/searchResult/detail': (context) => DetailPage(),
        '/about': (context) => AboutPage()
      },
    ),
  );
}