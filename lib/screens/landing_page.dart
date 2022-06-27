// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/constants.dart';
import 'package:food_delivery_app/screens/home_page.dart';
import 'package:food_delivery_app/screens/login_page.dart';
import 'package:food_delivery_app/services/firebase_services.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        //If snapshot has error
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }
        //connection initialized - app running
        if (snapshot.connectionState == ConnectionState.done) {
          //StreamBuilder can check the login state live
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              //If streamSnapshot has error
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('Error: ${streamSnapshot.error}'),
                  ),
                );
              }
              //Connection state active - Do the user login check inside the if
              if (streamSnapshot.connectionState == ConnectionState.active) {
                //Get the user
                var _user = streamSnapshot.data;
                //print(_user.runtimeType);
                if (_user == null) {
                  //user not logged in - go to LoginPage
                  return LoginPage();
                } else {
                  //user logged in - go to HomePage
                  FirebaseServices.addSearchFields();
                  return HomePage();
                }
              }
              //Checking the auth state - loading
              return Scaffold(
                body: Center(
                  child: Text(
                    'Checking Authentification ...',
                    style: Constants.regularHeading,
                  ),
                ),
              );
            },
          );
        }
        //Connecting to Firebase - loading
        return Scaffold(
          body: Center(
            child: Text(
              'Initializing App...',
              style: Constants.regularHeading,
            ),
          ),
        );
      },
    );
  }
}
