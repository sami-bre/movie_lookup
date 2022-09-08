import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'main.dart'; // this imports the api_key

class SearchResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // we assume the argument is never null and get the data (search result)
    String movieTitle = ModalRoute.of(context)!.settings.arguments as String;
    Future<http.Response> futureData = http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=$api_key&query="$movieTitle"'));
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: FutureBuilder(
            future: futureData,
            builder:
                (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> data = json.decode(snapshot.data!.body);
                return buildGridView(data);
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.wifi_off,
                          size: 60.0,
                        ),
                      ),
                      Text(
                        'Oops!\nNetwork error.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildGridView(Map data) {
    // extract some useful items from the data
    int resultCount = (data['results'] as List).length;
    List results = data['results'];
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 284.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: resultCount,
      itemBuilder: (context, index) {
        // again, extracting some useful movie-specific data
        String title = results[index]['original_title'];
        // make the title not too long
        // if(title.length > 34) title = '${title.substring(0, 34)} ...';
        String imagePath =
            'https://image.tmdb.org/t/p/w185${results[index]['poster_path']}';
        return GestureDetector(
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.network(
                  imagePath,
                  height: 210.0,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) {
                      return child;
                    } else {
                      return const SizedBox(
                        height: 210,
                        child: Center(
                          child: SizedBox(
                            width: 50,
                            child: LinearProgressIndicator(),
                          ),
                        ),
                      );
                    }
                  },
                  errorBuilder: (context, obj, trace) {
                    return SizedBox(
                      height: 210,
                      child: Center(
                        child: Text(
                          'No image',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
          onTap: () => _goToDetailPage(context, data['results'][index]),
        );
      },
    );
  }

  // Actions ...

  void _goToDetailPage(BuildContext context, Map movieData) {
    Navigator.pushNamed(
      context,
      '/searchResult/detail',
      arguments: movieData,
    );
  }
}