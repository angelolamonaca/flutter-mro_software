// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),

        /*
        * The itemBuilder callback is called once per suggested word pairing,
        * and places each suggestion into a ListTile row.
        * Note that the divider might be difficult to see on smaller devices.
        */
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

          /*
          * If you’ve reached the end of the available word pairings,
          * then generate 10 more and add them to the suggestions list.
          */
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          /* For even rows, the function adds a ListTile row for the word pairing. */
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(pair.asPascalCase, style: _biggerFont),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
        semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),
    );
  }
}
