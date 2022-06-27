// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, deprecated_member_use, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/constants.dart';
import 'package:food_delivery_app/screens/product_page.dart';
import 'package:food_delivery_app/services/firebase_services.dart';
import 'package:food_delivery_app/widgets/custom_action_bar.dart';
import 'package:food_delivery_app/widgets/custom_button.dart';
import 'package:food_delivery_app/widgets/custom_input.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<void> _addToSaved(num total, String address) async {
    return FirebaseServices.usersRef
        .doc(FirebaseServices.getUserId())
        .collection('Orders')
        .doc()
        .set({
      'total': total,
      'address': address,
      'status': 1,
      //order status field -> value Random().nextInt(3) + 1
      //write a cloud function to switch value with delay
    });
  }

  late num orderTotal;

  final SnackBar _orderSnackBar =
      SnackBar(content: Text('Check added to the orders'));

  final SnackBar _removeSnackBar =
      SnackBar(content: Text('Product reomoved from cart!'));

  Future _removeFromCart(var document) {
    return FirebaseServices.usersRef
        .doc(FirebaseServices.getUserId())
        .collection('Cart')
        .doc(document)
        .delete();
  }

  String _addressString = '';

  Future<num> calculateTotal() async {
    //setState(() {});
    num t = 0;
    await FirebaseServices.usersRef
        .doc(FirebaseServices.getUserId())
        .collection('Cart')
        .get()
        .then(
          (value) => value.docs.forEach(
            (element) {
              t += element['price'] * element['count'];
            },
          ),
        );
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
              future: FirebaseServices.usersRef
                  .doc(FirebaseServices.getUserId())
                  .collection('Cart')
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
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.only(
                            top: 108.0,
                            bottom: 12.0,
                          ),
                          children: snapshot.data!.docs.map((document) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductPage(
                                      productId: document.id,
                                    ),
                                  ),
                                );
                              },
                              child: FutureBuilder<dynamic>(
                                  future: FirebaseServices.productsRef
                                      .doc(document.id)
                                      .get(),
                                  builder: (context, productSnapshot) {
                                    if (productSnapshot.hasError) {
                                      return Container(
                                        child: Center(
                                          child:
                                              Text('${productSnapshot.error}'),
                                        ),
                                      );
                                    }
                                    if (productSnapshot.connectionState ==
                                        ConnectionState.done) {
                                      Map _productMap =
                                          productSnapshot.data.data();
                                      //if (document['count'] != null) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16.0,
                                          horizontal: 24.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 90,
                                                  height: 90,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.network(
                                                      "${_productMap['images'][0] ?? ''}",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    left: 16.0,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${_productMap['name'] ?? 'name'}",
                                                        style: TextStyle(
                                                            fontSize: 18.0,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 4.0,
                                                        ),
                                                        child: Text(
                                                          "\$ ${document['price']}", //* document['count']
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .secondary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                      Text(
                                                        "Count - ${document['count']}",
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _removeFromCart(document.id);
                                                setState(() {});
                                                Scaffold.of(context)
                                                    .showSnackBar(
                                                        _removeSnackBar);
                                              },
                                              child: Container(
                                                child: Icon(
                                                  Icons.close,
                                                  size: 42,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                      //}
                                    }
                                    return Container(
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          }).toList(),
                        ),
                      ),
                      Container(
                        //margin: EdgeInsets.only(bottom: 20),
                        padding: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(15)),
                        ),
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FutureBuilder<num>(
                                future: calculateTotal(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    orderTotal = snapshot.data!;
                                    return Text(
                                      'TOTAL : ${snapshot.data}\$',
                                      style: Constants.boldHeading,
                                    );
                                  }
                                  return CircularProgressIndicator();
                                }),
                            CustomInput(
                              hintText: 'Enter address',
                              onSubmitted: (value) {
                                _addressString = value;
                              },
                            ),
                            CustomButton(
                              outlineButton: false,
                              text: 'Order',
                              onPressed: () async {
                                if (orderTotal > 0 && _addressString != '') {
                                  setState(() {
                                    _addToSaved(orderTotal, _addressString);
                                    //change status after time period
                                    //
                                    //---delete all data from cart
                                    FirebaseServices.usersRef
                                        .doc(FirebaseServices.getUserId())
                                        .collection('Cart')
                                        .get()
                                        .then((snapshot) {
                                      for (DocumentSnapshot ds
                                          in snapshot.docs) {
                                        ds.reference.delete();
                                      }
                                    });
                                  });
                                  Scaffold.of(context)
                                      .showSnackBar(_orderSnackBar);
                                } else {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Invalid data to order'),
                                  ));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
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
            hasBackArrrow: true,
            title: 'Cart',
          ),
        ],
      ),
    );
  }
}
