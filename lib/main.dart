// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aircraft Inspection Checklist',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          )),
      home: const InspectionItems(),
    );
  }
}

class InspectionItems extends StatefulWidget {
  const InspectionItems({Key? key}) : super(key: key);

  @override
  _InspectionItemsState createState() => _InspectionItemsState();
}

class _InspectionItemsState extends State<InspectionItems> {
  final _done = <String>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  final _inspectionList = [
    "Oil Change",
    "Equipment List",
    "ELT Battery",
    "Altimeter System",
    "Pitot",
    "Transponder",
    "VOD Operational Check",
    "Airworthness Certificate",
    "Carbon Monoxide Detector",
    "Survival Kit",
    "Serviceable Fire Extinguisher",
    "Tires",
    "Anti Collision Strobe",
    "Cabin"
  ];

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),

        /*
        * The itemBuilder callback is called once per suggested word pairing,
        * and places each suggestion into a ListTile row.
        * Note that the divider might be difficult to see on smaller devices.
        */
        itemCount: _inspectionList.length*2,
        itemBuilder: (context, i) {
          /*
          * For odd rows, a one-pixel-high divider widget before each row in the ListView,
          * to visually separate the entries.
          */
          if (i.isOdd) {
            return const Divider();
          }

          /*
          * The expression i ~/ 2 divides i by 2 and returns an integer result.
          * For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          * This calculates the actual number of word pairings in the ListView,
          * minus the divider widgets.
          */
          final index = i ~/ 2;

          /* For even rows, the function adds a ListTile row for the word pairing. */
          return _buildRow(_inspectionList[index]);
        });
  }

  Widget _buildRow(String inspectionItem) {
    final alreadySaved = _done.contains(inspectionItem);
    return ListTile(
      title: Text(inspectionItem, style: _biggerFont),
      trailing: Icon(
        alreadySaved
            ? Icons.check_box_outlined
            : Icons.check_box_outline_blank_outlined,
        color: alreadySaved ? Colors.green : Colors.red,
        semanticLabel: alreadySaved ? 'Remove from done' : 'Save',
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _done.remove(inspectionItem);
          } else {
            _done.add(inspectionItem);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aircraft Inspection Checklist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Done Inspections',
          ),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _done.map(
                (inspectionItem) {
              return ListTile(
                title: Text(
                  inspectionItem,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Done Inspections'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}
