// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/services/firebase_services.dart';

class BottomTabs extends StatefulWidget {
  final int? selectedTab;
  final Function(int)? tabPressed;
  BottomTabs({Key? key, this.selectedTab, this.tabPressed}) : super(key: key);

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    Future<void> nextStep() async {
      FirebaseServices.usersRef
          .doc(FirebaseServices.getUserId())
          .collection('Orders')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          if (ds['status'] == 1) {
            Future.delayed(Duration(seconds: Random().nextInt(15) + 5), () {
              //Random().nextInt(15) + 5
              ds.reference.update({'status': 2});
            });
          } else if (ds['status'] == 2) {
            Future.delayed(Duration(seconds: Random().nextInt(120) + 60), () {
              ds.reference.update({'status': 3});
            });
          }
        }
      });
    }

    _selectedTab = widget.selectedTab ?? 0;

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1.0,
              blurRadius: 30.0,
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomTabButton(
            imagePath: "assets/images/tab_home.png",
            selected: _selectedTab == 0 ? true : false,
            onPressed: () {
              widget.tabPressed!(0);
            },
          ),
          BottomTabButton(
            imagePath: "assets/images/tab_search.png",
            selected: _selectedTab == 1 ? true : false,
            onPressed: () {
              widget.tabPressed!(1);
            },
          ),
          BottomTabButton(
              imagePath: "assets/images/tab_saved.png",
              selected: _selectedTab == 2 ? true : false,
              onPressed: () {
                widget.tabPressed!(2);
                nextStep();
              }),
          BottomTabButton(
            imagePath: "assets/images/tab_logout.png",
            selected: _selectedTab == 3 ? true : false,
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
    );
  }
}

class BottomTabButton extends StatelessWidget {
  final String? imagePath;
  final bool? selected;
  final Function()? onPressed;
  BottomTabButton({Key? key, this.imagePath, this.selected, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _selected = selected ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 28.0,
          horizontal: 24.0,
        ),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
          color: _selected
              ? Theme.of(context).colorScheme.secondary
              : Colors.transparent,
          width: 2.0,
        ))),
        child: Image(
          image: AssetImage(imagePath ?? "assets/images/tab_home.png"),
          width: 22.0,
          height: 22.0,
          color: _selected
              ? Theme.of(context).colorScheme.secondary
              : Colors.black,
        ),
      ),
    );
  }
}
