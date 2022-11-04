import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/image_input.dart';
import '../widgets/location_input.dart';
import '../providers/great_places.dart';
import '../models/place.dart';
import './places_list_screen.dart';
import '../widgets/hidden.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File _pickedImage;
  PlaceLocation _pickedLocation;
  bool hidden = false;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _hidden(bool isHidden) {
    hidden = isHidden;
    //debugPrint(hidden.toString());
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
  }

  void _savePlace() {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null) {
      return;
    }
    Provider.of<GreatPlaces>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage, _pickedLocation);
    Provider.of<PlacesListScreenState>(context, listen: false)
        .shootConfetti(); // where the confetti is called
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text('Add a New Place'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(labelText: 'Title'),
                          controller: _titleController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ImageInput(_selectImage),
                        SizedBox(
                          height: 10,
                        ),
                        LocationInput(_selectPlace),
                      ],
                    ),
                    LocationInput(_selectPlace),
                    SizedBox(
                      height: 10,
                    ),
                    HiddenInput(_hidden),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Place'),
            onPressed: _savePlace,
            style: ElevatedButton.styleFrom(
              primary: Colors.teal,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPrimary: Theme.of(context).accentColor,
              shadowColor: Colors.red,
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}
