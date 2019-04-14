import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class FirestoreSlideshow extends StatefulWidget {
  createState() => FirestoreSlideshowState();
}

class FirestoreSlideshowState extends State<FirestoreSlideshow> {
  final PageController pageController = PageController(viewportFraction: 0.8);
  final Firestore firestore = Firestore.instance;
  Stream slides;
  String activeSlideTag = 'favourites';
  int currentPage = 0;

  @override
  void initState() {
    queryFirestore();
    pageController.addListener(() {
      // Get the rounded to integer page
      // (because it returns fractions based on how much of the page is visible)
      int nextPage = pageController.page.round();
      if (currentPage != nextPage) {
        setState(() {
          currentPage = nextPage;
        });
      }
    });

    super.initState();
  }

  Stream queryFirestore({String tag = 'favourites'}) {
    Query q =
        firestore.collection('characters').where('tags', arrayContains: tag);

    slides = q
        .snapshots()
        .map((list) => list.documents.map((document) => document.data));
    setState(() {
      currentPage = 1;
      activeSlideTag = tag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: slides,
        initialData: [],
        builder: (context, AsyncSnapshot snapshot) {
          List slides = snapshot.data.toList();
          // debugPrint('hello');
          // debugPrint(slides.length.toString());
          // slides.forEach((f) => debugPrint(f['image']));
          // debugPrint(slides.length.toString());
          return PageView.builder(
              controller: pageController,
              itemCount: slides.length + 1,
              itemBuilder: (context, int currentIndex) {
                if (currentIndex == 0) {
                  return _buildTagPage();
                } else if (slides.length >= currentIndex) {
                  bool isActive = currentIndex == currentPage;
                  return _buildStoryPage(slides[currentIndex - 1], isActive);
                }
              });
        });
  }

  Widget _buildStoryPage(slide, bool isActive) {
    final double blur = isActive ? 30 : 0;
    final double offset = isActive ? 20 : 0;
    final double top = isActive ? 100 : 200;
    return _buildAnimatedCard(blur, offset, top, slide);
  }

  AnimatedContainer _buildAnimatedCard(blur, offset, top, slide) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
        decoration: _buildDecoration(blur, offset, top, slide),
        margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
        child: Center(
          child: Text(slide['name'],
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ));
  }
  AnimatedContainer _buildAnimatedCard2(blur, offset, top, slide) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
        decoration: _buildDecoration(blur, offset, top, slide),
        margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
        child: Center(
          child: Text(slide['name'],
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ));
  }

  Decoration _buildDecoration(blur, offset, top, slide) {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black87,
            blurRadius: blur,
            offset: Offset(offset, offset),
          )
        ],
        image: DecorationImage(
            fit: BoxFit.cover, image: NetworkImage(slide['image'])));
  }

  Widget _buildTagPage() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Stories',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text('FILTER', style: TextStyle(color: Colors.black26)),
        _buildButton('favourites'),
        _buildButton('all')
      ],
    ));
  }

  _buildButton(tag) {
    Color color = tag == activeSlideTag ? Colors.purple : Colors.white;
    return FlatButton(
        color: color,
        child: Text('#$tag'),
        onPressed: () => queryFirestore(tag: tag));
  }
}
