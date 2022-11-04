import 'package:flutter/material.dart';
import 'dart:io';

class HiddenInput extends StatefulWidget {
  final Function onHide;

  HiddenInput(this.onHide);

  @override
  _HiddenInputState createState() => _HiddenInputState();
}

class _HiddenInputState extends State<HiddenInput> {
  bool hidden = false;

  void _hidden() {
    setState(() {
      if (hidden ? hidden = false : hidden = true) ;
    });
    widget.onHide(hidden);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: hidden
          ? Icon(
              Icons.hide_image,
            )
          : Icon(
              Icons.image,
            ),
      label: Text('Hide Image?',
          style: TextStyle(color: Theme.of(context).primaryColor)),
      onPressed: _hidden,
    );
  }
}
