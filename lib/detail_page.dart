import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // this sets the orientation of the route.
    // preferred orientation should be set for each route.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
      },
    );
  }
}
