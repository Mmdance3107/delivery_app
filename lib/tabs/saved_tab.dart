// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/services/firebase_services.dart';
import 'package:food_delivery_app/widgets/custom_action_bar.dart';
import 'package:food_delivery_app/widgets/status_bar.dart';

class SavedTab extends StatefulWidget {
  const SavedTab({Key? key}) : super(key: key);

  @override
  State<SavedTab> createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
              future: FirebaseServices.usersRef
                  .doc(FirebaseServices.getUserId())
                  .collection('Orders')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                }
                //Collection data ready to display
                if (snapshot.connectionState == ConnectionState.done) {
                  //Display the data inside a ListView
                  return ListView(
                    padding: EdgeInsets.only(
                      top: 108.0,
                      bottom: 12.0,
                    ),
                    children: snapshot.data!.docs.map((document) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left: 16.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Address: ${document['address']}",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: Text(
                                      "Total: \$${document['total']}",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Text('Order id: ${document.id}'),
                                  Text('---------------------'),
                                  //StatusBar(ticks: 1),
                                  StatusBar(ticks: document['status']),

                                  //
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }
                //Loading state
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                );
              }),
          CustomActionBar(
            title: 'Saved orders',
          ),
        ],
      ),
    );
  }
}
