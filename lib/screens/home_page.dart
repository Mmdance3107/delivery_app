// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:food_delivery_app/constants.dart';
import 'package:food_delivery_app/tabs/home_tab.dart';
import 'package:food_delivery_app/tabs/saved_tab.dart';
import 'package:food_delivery_app/tabs/search_tab.dart';
import 'package:food_delivery_app/widgets/bottom_tabs.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController? _tabsPageController;
  int _selectedTab = 0;

  @override
  void initState() {
    _tabsPageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tabsPageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: PageView(
              controller: _tabsPageController,
              onPageChanged: (number) {
                setState(() {
                  _selectedTab = number;
                });
              },
              children: [
                HomeTab(),
                SearchTab(),
                SavedTab(),
              ],
            ),
          ),
          BottomTabs(
            selectedTab: _selectedTab,
            tabPressed: (number) {
              setState(() {
                _tabsPageController!.animateToPage(number,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic);
              });
            },
          ),
        ],
      ),
    );
  }
}
