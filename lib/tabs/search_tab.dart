// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/constants.dart';
import 'package:food_delivery_app/services/firebase_services.dart';
import 'package:food_delivery_app/widgets/custom_input.dart';
import 'package:food_delivery_app/widgets/product_card.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  String _searchString = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if (_searchString.isEmpty)
            Center(
              child: Text(
                'Search Results',
                style: Constants.regularDarkText,
              ),
            )
          else
            FutureBuilder<QuerySnapshot>(
                future: FirebaseServices.productsRef.orderBy('search').startAt(
                    [_searchString]).endAt(["$_searchString\uf8ff"]).get(),
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
                        top: 128.0,
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
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: CustomInput(
              hintText: 'Search here...',
              onSubmitted: (value) {
                setState(() {
                  _searchString = value.toLowerCase();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
