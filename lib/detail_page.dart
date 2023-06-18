import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/news.dart';
import 'package:news_app/models/news.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // this sets the orientation of the route.
    // preferred orientation should be set for each route.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // we assume the argument will never be null
    News news = ModalRoute.of(context)!.settings.arguments as News;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          news.title,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildPosterImage(news.urlToImage ?? 'default image path'),
                  const SizedBox(height: 14.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                      child: Text(
                        news.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontSize: 20),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14.0),
                  Padding(
                    padding: EdgeInsets.all(3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Published by: ${news.author ?? "unknown"}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          'On ${news.publishedAt}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14.0),
                  Text(
                    news.description,
                    softWrap: true,
                  ),
                ],
              ),
            );
          }),
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
