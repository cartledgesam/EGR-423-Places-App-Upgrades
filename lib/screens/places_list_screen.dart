import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';

import './add_place_screen.dart';
import '../providers/great_places.dart';
import './place_detail_screen.dart';

class PlacesListScreen extends StatefulWidget with ChangeNotifier {
  @override
  State<PlacesListScreen> createState() => PlacesListScreenState();
}

class PlacesListScreenState extends State<PlacesListScreen>
    with ChangeNotifier {
  static bool isConfettiPlaying = false;
  static final confettiController = ConfettiController();

  void shootConfetti() {
    // notifyListeners();
    if (isConfettiPlaying) {
      confettiController.stop();
    } else {
      confettiController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text('Your Places'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
                },
              ),
            ],
          ),
          body: FutureBuilder(
            future: Provider.of<GreatPlaces>(context, listen: false)
                .fetchAndSetPlaces(),
            builder: (ctx, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<GreatPlaces>(
                    child: Center(
                      child:
                          const Text('Got no places yet, start adding some!'),
                    ),
                    builder: (ctx, greatPlaces, ch) =>
                        greatPlaces.items.length <= 0
                            ? ch
                            : ListView.builder(
                                itemCount: greatPlaces.items.length,
                                itemBuilder: (ctx, i) => ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: FileImage(
                                      greatPlaces.items[i].image,
                                    ),
                                  ),
                                  title: Text(greatPlaces.items[i].title),
                                  subtitle: Text(
                                      greatPlaces.items[i].location.address),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      PlaceDetailScreen.routeName,
                                      arguments: greatPlaces.items[i].id,
                                    );
                                  },
                                ),
                              ),
                  ),
          ),
        ),
        ConfettiWidget(
          confettiController: confettiController,
          shouldLoop: false,
          blastDirectionality: BlastDirectionality.explosive,
          numberOfParticles: 20,
        ),
      ],
    );
  }
}
