import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class StartPage extends StatefulWidget {
  @override
  StartPageState createState() => StartPageState();
}

class StartPageState extends State<StartPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // this sets the orientation of the route.
    // preferred orientation should be set for each route.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage(
              //       'interstellar.jpg'),
              //   opacity: 0.3,
              //   fit: BoxFit.cover,
              // ),
              ),
          child: Column(
            children: <Widget>[
              const Expanded(flex: 8, child: SizedBox.shrink()),
              _buildSearchArea(context),
              const Expanded(flex: 4, child: SizedBox.shrink()),
              const Expanded(flex: 1, child: SizedBox.shrink())
            ],
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
            textAlign: TextAlign.center,
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
    // check that the title is not empty and push the searchResults route. (using some jargon :)
    if (movieTitle != '') {
      Navigator.pushNamed(
        context,
        '/searchResult',
        arguments: movieTitle,
      );
    }
  }
}
