import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // this sets the orientation of the route.
    // preferred orientation should be set for each route.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // we assume the argument will never be null
    Map articleData = ModalRoute.of(context)!.settings.arguments as Map;


    String imagePath = articleData['urlToImage'];
    String publishedAt = articleData['publishedAt'];
    String author = articleData['author'];
    String description = articleData['description'];
    String title = articleData['title'];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildPosterImage(imagePath),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(3),
                child: Text(
                  'Published by: $author on $publishedAt',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              )),
              Expanded(
                  flex: 2,
                  child: Text(
                    '$description',
                    softWrap: true,
                  )),

            ],
          ),
        ),
      ),
    );
  }


  Widget _buildPosterImage(String imagePath) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      decoration: const BoxDecoration(
          border: Border.symmetric(
              horizontal: BorderSide(width: 4.0, color: Colors.blue))),
      child: Image.network(
        imagePath,
        height: 290.0,
        fit: BoxFit.fitWidth,
        loadingBuilder: (context, child, progress) {
          if (progress == null) {
            return child;
          } else {
            return const SizedBox(
              height: 290.0,
              child: Center(
                child: SizedBox(
                  width: 60.0,
                  child: LinearProgressIndicator(),
                ),
              ),
            );
          }
        },
        errorBuilder: (context, __, ___) {
          return SizedBox(
            height: 290.0,
            child: Center(
              child: Text(
                'No image',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          );
        },
      ),
    );
  }

}