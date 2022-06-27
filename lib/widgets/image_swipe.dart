// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';

class ImageSwipe extends StatefulWidget {
  final List? imageList;
  ImageSwipe({this.imageList});

  @override
  _ImageSwipeState createState() => _ImageSwipeState();
}

class _ImageSwipeState extends State<ImageSwipe> {
  int _selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      child: Stack(
        children: [
          PageView(
            onPageChanged: (number) {
              setState(() {
                _selectedPage = number;
              });
            },
            children: [
              for (var i = 0; i < widget.imageList!.length; i++)
                Container(
                  child: Image.network(
                    '${widget.imageList![i]}',
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < widget.imageList!.length; i++)
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: _selectedPage == i ? 25 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
