// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, avoid_unnecessary_containers, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/constants.dart';
import 'package:food_delivery_app/services/firebase_services.dart';
import 'package:food_delivery_app/widgets/custom_action_bar.dart';
import 'package:food_delivery_app/widgets/image_swipe.dart';

class ProductPage extends StatefulWidget {
  ProductPage({required this.productId});
  final String productId;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _selectedProductAmount = 1;

  Future _addToCart() async {
    DocumentSnapshot value =
        await FirebaseServices.productsRef.doc(widget.productId).get();
    return FirebaseServices.usersRef
        .doc(FirebaseServices.getUserId())
        .collection('Cart')
        .doc(widget.productId)
        .set({
      'count': _selectedProductAmount,
      'price': value['price'],
    }, SetOptions(merge: true));
  }

  void addCount() {
    setState(() {
      _selectedProductAmount += 1;
    });
    //_addToCart();
  }

  void removeCount() {
    if (_selectedProductAmount > 1) {
      setState(() {
        _selectedProductAmount -= 1;
      });

      // _addToCart();
    }
  }

  final SnackBar _cartSnackBar = SnackBar(
    content: Text('Product added to the cart'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
            child: FutureBuilder<dynamic>(
          future: FirebaseServices.productsRef.doc(widget.productId).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            }
            //if (snapshot.connectionState == ConnectionState.done) {
            //Firebase Document Data Map
            Map<String, dynamic> documentData = snapshot.data!.data();
            //List of images
            List imageList = documentData['images'];
            //var productCount = documentData['count'];
            //_selectedProductSize = productCount;
            return ListView(
              padding: EdgeInsets.all(0),
              children: [
                ImageSwipe(imageList: imageList),
                ////////////////
                Padding(
                  padding:
                      EdgeInsets.only(left: 24, right: 24, top: 15, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${documentData['name']}', // ?? 'Product name'
                        style: Constants.boldHeading,
                      ),
                      SizedBox(height: 15),
                      Text(
                        '\$ ${documentData['price']}', // ?? 'Product price'
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      SizedBox(height: 15),
                      Text(
                        '${documentData['desc']}', // ?? 'Product desc'
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Select amount',
                        style: Constants.regularDarkText,
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: removeCount,
                          ),
                          Container(
                            width: 64,
                            height: 42,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xFFDCDCDC),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('$_selectedProductAmount'), //
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: addCount,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          await _addToCart();
                          Scaffold.of(context).showSnackBar(_cartSnackBar);
                        },
                        child: Container(
                          child: Text(
                            'Add to cart',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        )),
        CustomActionBar(
          hasBackArrrow: true,
          hasTitle: false,
          hasBackground: false,
        ),
      ],
    ));
  }
}
