// 4 cards being shown at the bottom of the homepage

import 'package:flutter/material.dart';
import 'Complaints.dart';
import 'Council.dart';
import 'Mess.dart';
import 'Events.dart';
import 'Utils/globals.dart';

class FunctionalityCardHomePage extends StatefulWidget {

  // name of the card
  final String _name;
  final String _image_path;

  FunctionalityCardHomePage(this._name, this._image_path);

  @override
  State<FunctionalityCardHomePage> createState() => _FunctionalityCardHomePageState();
}

class _FunctionalityCardHomePageState extends State<FunctionalityCardHomePage> {
  @override

  Widget build(BuildContext context) {

    // center the column horizontally
    return GestureDetector(

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
            (
                widget._name == Utils.MESS ? const Mess() :
                widget._name == Utils.COMPLAINTS ? const Complaints() :
                widget._name == Utils.EVENTS ? const Events() :
                const Council()
            )
          ),
        );
      },
      child: Card(
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                widget._image_path,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                widget._name,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}