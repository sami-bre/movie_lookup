import 'package:flutter/material.dart';
import 'dart:math' as math;

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
  'vive_la_france.jpg',
  'die_in_the_west.jpg',
  'spongebob.jpg',
  'war_room.jpg',
  'hacksaw_ridge.jpg',
  'game_of_thrones.jpg',
];

class StartPage extends StatefulWidget {
  @override
  StartPageState createState() => StartPageState();
}

class StartPageState extends State<StartPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  posterPaths[math.Random().nextInt(posterPaths.length)]),
              opacity: 0.3,
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              const Expanded(flex: 8, child: SizedBox.shrink()),
              _buildSearchArea(context),
              const Expanded(flex: 4, child: SizedBox.shrink()),
              TextButton(
                onPressed: (){
                  Navigator.pushNamed(
                    context,
                    '/about'
                  );
                },
                child: const Text('About', textScaleFactor: 1.2,),
              ),
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
    if(movieTitle != ''){
      Navigator.pushNamed(
        context,
        '/searchResult',
        arguments: movieTitle,
      );
    }
  }
}
