import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:moverviews/models/news.dart';
import 'package:moverviews/util/httpHellper.dart';
import 'dart:convert';

import 'main.dart'; // this imports the api_key

class SearchResultPage extends StatefulWidget {
  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  TextEditingController controller = TextEditingController();

  Icon visibleIcon = Icon(Icons.search);
  Widget searchBar = Text('Top News');
  @override
  Widget build(BuildContext context) {
    // this sets the orientation of the route.
    // preferred orientation should be set for each route.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);

    // String newsHeadline = ModalRoute.of(context)!.settings.arguments as String;
    // Future<http.Response> searchQuery = http.get(Uri.parse(
    //     'https://newsapi.org/v2/top-headlines?country=us&access_key=$api_key&query=$controller'));

// MODIFY THE URL TO INCLUDE SOMETHING LIKE "LATEST" OR "TOPNEWS"
    Future<List<News>> latestNews = HttpHelper().getLatestNews();

    return Scaffold(
      appBar: AppBar(title: searchBar, centerTitle: true, actions: <Widget>[
        IconButton(
          icon: visibleIcon,
          onPressed: () {
            setState(() {
              if (this.visibleIcon.icon == Icons.search) {
                this.visibleIcon = Icon(Icons.cancel);
                this.searchBar = TextField(
                  textInputAction: TextInputAction.search,
                  onSubmitted: (String text) {},
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                );
              } else {
                setState(() {
                  this.visibleIcon = Icon(Icons.search);
                  this.searchBar = Text('Top News');
                });
              }
            });
          },
        ),
      ]),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: FutureBuilder<List<News>>(
            future: latestNews,
            builder:
                (BuildContext context, AsyncSnapshot<List<News>> snapshot) {
              if (snapshot.hasData) {
                var news_list = snapshot.data!;
                if (news_list.isEmpty) {
                  return buildNoNewsFoundWidget(context);
                } else {
                  return buildGridView(news_list);
                }
              } else if (snapshot.hasError) {
                return buildNetworkProblemWidget(context);
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

  Widget buildNoNewsFoundWidget(BuildContext context) {
    return buildDataFetchProblemWidget(context,
        problemText: 'Nothing found',
        iconThing: Image.asset(
          'assets/illustrations/nothing_found.gif',
          width: 260.0,
        ));
  }

  Widget buildNetworkProblemWidget(BuildContext context) {
    return buildDataFetchProblemWidget(context,
        problemText: 'Oops!\nNetwork error.',
        iconThing: Image.asset(
          'assets/illustrations/network_problem.gif',
          width: 260.0,
        ));
  }

  Center buildDataFetchProblemWidget(
    BuildContext context, {
    required String problemText,
    Widget? iconThing,
  }) {
    // this is a relatively lower level widget returning method that gets
    // called by other widget returning methods.
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (iconThing != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: iconThing,
            ),
          Text(
            problemText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget buildGridView(List<News> newsList) {
    // extract some useful items from the data
    int resultCount = newsList.length;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        int cardCountPerRow = constraints.biggest.width ~/ 140;
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cardCountPerRow,
            mainAxisExtent: 284.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: resultCount,
          itemBuilder: (context, index) {
            // again, extracting some useful movie-specific data
            String title = newsList[index].title;
            // make the title not too long
            // if(title.length > 34) title = '${title.substring(0, 34)} ...';
            String imagePath = newsList[index].urlToImage ?? '';
            return GestureDetector(
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.network(
                      imagePath,
                      height: 210.0,
                      fit: BoxFit.cover,
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
              onTap: () => {}, // _goToDetailPage(context, newsList[index]),
            );
          },
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
