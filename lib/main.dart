import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

const String api_key = 'a5d01b4d751380e044e2246e605df108';

const posterPaths = [
  'cloverfield_paradox.jpg',
  'get_out.jpg',
  'interstellar.jpg',
  'lord_of_the_rings.jpg',
  'the_dictator.jpg',
  'the_social_network.jpg',
  'despicable_me.jpg',
  'home.jpg',
  'iron_man_2.jpg',
  'me_before_you.jpg',
  'the_interview.jpg',
  'vive_la_france.jpg'
];

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

class StartPage extends StatefulWidget {
  @override
  StartPageState createState() => StartPageState();
}

class StartPageState extends State<StartPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(posterPaths[math.Random().nextInt(12)]),
            opacity: 0.3,
            fit: BoxFit.cover,
          )),
          child: Center(
            child: _buildSearchArea(context),
          ),
        ),
      ),
    );
  }

  // Build ...

  Widget _buildSearchArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Search Movies',
            style: Theme.of(context).textTheme.headline4,
          ),
          TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Movie Title'),
          ),
          const SizedBox(height: 4.0),
          ElevatedButton(
            onPressed: () => _search(controller.text),
            child: const Text('Search'),
          )
        ],
      ),
    );
  }

  // Actions ...

  void _search(String movieTitle) {
    Navigator.pushNamed(
      context,
      '/searchResult',
      arguments: movieTitle,
    );
  }
}

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
                  child: Text(
                    'Oops!, Data could not be fetched.',
                    style: Theme.of(context).textTheme.titleLarge,
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

class DetailPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // we assume the argument will never be null
    Map movieData = ModalRoute.of(context)!.settings.arguments as Map;
    String imagePath =
        'https://image.tmdb.org/t/p/w500${movieData['poster_path']}';
    // get some important pieces from the movieData
    String title = movieData['original_title'].toString();
    String releaseYear = (movieData['release_date']! as String).substring(0, 4);
    double rating = (movieData['vote_average'] as num).toDouble();
    String overview = movieData['overview'];
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
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => _showOverview(context, overview),
                    child: const Text('Look at overview'),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: buildReleaseRatingTable(context, releaseYear, rating),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildReleaseRatingTable(
      BuildContext context, String releaseYear, double rating) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        children: <TableRow>[
          TableRow(
            children: <Text>[
              Text(
                'Release',
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
              Text(
                'Rating',
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          TableRow(
            children: <Text>[
              Text(
                releaseYear,
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              Text(
                '$rating',
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
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

  // Actions ...

  void _showOverview(BuildContext context, overview) {
    // this is supposed to display an alert box with the movie overview in it
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Overview'),
            content: SingleChildScrollView(
              child: Text(
                overview,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          );
        });
  }
}
