// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/services/firebase_services.dart';
import 'package:food_delivery_app/widgets/custom_action_bar.dart';
import 'package:food_delivery_app/widgets/product_card.dart';

class HomeTab extends StatelessWidget {
  HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
              future: FirebaseServices.productsRef.get(),
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
                      return ProductCard(
                        title: document['name'],
                        imageUrl: '${document['images'][0]}',
                        price: '${document['price']}',
                        productId: document.id,
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
            title: 'Home',
          ),
        ],
      ),
    );
  }
}
