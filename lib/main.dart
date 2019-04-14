import 'package:flutter/material.dart';

import 'package:english_words/english_words.dart';
import 'package:gloomhaven_character_manager/FirestoreSlideshow.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // final PageController pageController = PageController();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'GH Character Manager',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          // fontFamily: 'Pirata One'
        ),
        home: Scaffold(
            appBar: AppBar(title: Text('GH Character Manager')),
            body: FirestoreSlideshow())
        //  PageView(
        //   scrollDirection: Axis.horizontal,
        //   controller: pageController,
        //   children: <Widget>[
        //     Center(child: Text(WordPair.random().toString())),
        //     Container(color: Colors.indigo),
        //     Container(color: Colors.amber),
        //     Container(color: Colors.lightGreen),
        //     Container(color: Colors.lime),
        //   ],
        // )),
        );
  }
}
