import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

const String api_key = 'a5d01b4d751380e044e2246e605df108';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      routes: {
        '/': (context) => StartPage(),
        '/searchResult' : (context) => SearchResultPage(),
        // '/details': (context) => DetailPage()
      },
    ),
  );
}


class StartPage extends StatefulWidget{
  @override
  StartPageState createState() => StartPageState();
}


class StartPageState extends State<StartPage>{
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: _buildSearchArea(context),
          ),
        ),
    );
  }

  // Build ...

  Widget _buildSearchArea(BuildContext context){
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

  void _search(String movieTitle){
    Navigator.pushNamed(
      context,
      '/searchResult',
      arguments: movieTitle
    );
  }
}


class SearchResultPage extends StatelessWidget{
  
  @override
  Widget build(BuildContext context){
    // we assume the argument is never null and get the data (search result)
    String movieTitle = ModalRoute.of(context)!.settings.arguments as String;
    Future<http.Response> futureData = http.get(Uri.parse('https://api.themoviedb.org/3/search/movie?api_key=$api_key&query="$movieTitle"'));
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: FutureBuilder(
            future: futureData,
            builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot){
              if(snapshot.hasData){
                Map<String, dynamic> data = json.decode(snapshot.data!.body);
                return buildGridView(data);
              } else if(snapshot.hasError){
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
            String imagePath = 'https://image.tmdb.org/t/p/w200${results[index]['poster_path']}';
            String overview = results[index]['overview'];
            return Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.network(
                    imagePath,
                    height: 210.0,
                    loadingBuilder: (context, child, progress) {
                      if(progress == null){
                        return child;
                      } else {
                        return const SizedBox(height: 210, child: Center(child: SizedBox(width: 50, child: LinearProgressIndicator(),),),);
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
            );
          },
        );
  }
}