import 'dart:convert';

import 'package:news_app/models/news.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  final String api_key = '68d94cd4257c407195ec66ebe5b749f7';

  Future<List<News>> getLatestNews() async {
    var latest = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?language=en&sources=cnn,bbc&apiKey=$api_key'));

    if (latest.statusCode == 200) {
      Map<String, dynamic> result = json.decode(latest.body);
      var data = result['articles'] as List;
      List<News> news = data.map((article) => News.fromJson(article)).toList();
      return news;
    } else {
      throw Exception('Failed to load latest news');
    }
  }

  Future<List<News>> searchNews(String query) async {
    var search = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?language=en&sources=cnn,bbc&q=$query&apiKey=$api_key'));

    if (search.statusCode == 200) {
      Map<String, dynamic> result = json.decode(search.body);
      var data = result['articles'] as List;
      List<News> news = data.map((article) => News.fromJson(article)).toList();
      return news;
    } else {
      throw Exception('Failed to load search results');
    }
  }
}
