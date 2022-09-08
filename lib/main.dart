import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'start_page.dart';
import 'search_results_page.dart';
import 'detail_page.dart';

const String api_key = 'a5d01b4d751380e044e2246e605df108';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      routes: {
        '/': (context) => StartPage(),
        '/searchResult': (context) => SearchResultPage(),
        '/searchResult/detail': (context) => DetailPage()
      },
    ),
  );
}