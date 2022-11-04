import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import '../providers/great_places.dart';
import './map_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  final LocalAuthentication auth = LocalAuthentication();
  static const routeName = '/place-detail';
  Future<bool> checkAuth() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    debugPrint(canAuthenticate.toString());
    debugPrint("Error authenticating");
    try {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to view image');
      debugPrint(didAuthenticate.toString());
      return Future.value(didAuthenticate);
    } on PlatformException {
      debugPrint("Error authenticating");
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    final selectedPlace =
        Provider.of<GreatPlaces>(context, listen: false).findById(id);
    if (selectedPlace.hidden) {
      return FutureBuilder<bool>(
          future: checkAuth(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return SizedBox.shrink();
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (snapshot.data == true) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(selectedPlace.title),
                      ),
                      body: Column(
                        children: <Widget>[
                          Container(
                            height: 250,
                            width: double.infinity,
                            child: Image.file(
                              selectedPlace.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            selectedPlace.location.address,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextButton(
                            child: Text('View on Map',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),

                            //textColor: Theme.of(context).primaryColor,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (ctx) => MapScreen(
                                    initialLocation: selectedPlace.location,
                                    isSelecting: false,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Text('Not authenticated');
                  }
                }
            }
          });
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(selectedPlace.title),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 250,
              width: double.infinity,
              child: Image.file(
                selectedPlace.image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              selectedPlace.location.address,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              child: Text('View on Map',
                  style: TextStyle(color: Theme.of(context).primaryColor)),

              //textColor: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (ctx) => MapScreen(
                      initialLocation: selectedPlace.location,
                      isSelecting: false,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
  }
}
