// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, avoid_unnecessary_containers, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/constants.dart';
import 'package:food_delivery_app/widgets/custom_button.dart';
import 'package:food_delivery_app/widgets/custom_input.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //build an alert dialog to display some errors
  Future<void> _alertDialogBuilder(String? error) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Container(
            child: Text(error!),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close Dialog'),
            )
          ],
        );
      },
    );
  }

//Create a new user account
  Future<String?> _createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail, password: _registerPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message!;
    } catch (e) {
      return e.toString();
    }
  }

  void _submitForm() async {
    //Set the form to loading state
    setState(() {
      _registerFormLoading = true;
    });
    //Run the create account method
    String? _createAccountFeedback = await _createAccount();
    //if string is not null, we got error while creating
    if (_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);
      //Set the form to regular(not loading) state
      setState(() {
        _registerFormLoading = false;
      });
    } else {
      //String is null, user is logged in, go to login page
      Navigator.pop(context);
    }
  }

//create default Form Loading State
  bool _registerFormLoading = false;
  //Form Input Field Values
  String _registerEmail = '';
  String _registerPassword = '';
  //focus node for input fields
  FocusNode? _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(top: 24),
                child: Text(
                  'Create A New Account',
                  textAlign: TextAlign.center,
                  style: Constants.boldHeading,
                ),
              ),
              Column(
                children: [
                  CustomInput(
                    hintText: 'Email',
                    onChanged: (value) {
                      _registerEmail = value;
                    },
                    onSubmitted: (value) {
                      _passwordFocusNode!.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  CustomInput(
                    hintText: 'Password',
                    isPasswordField: true,
                    onChanged: (value) {
                      _registerPassword = value;
                    },
                    onSubmitted: (value) {
                      _submitForm();
                    },
                    focusNode: _passwordFocusNode,
                  ),
                  CustomButton(
                    text: 'Create Account',
                    outlineButton: false,
                    onPressed: () {
                      _submitForm();
                    },
                    isLoading: _registerFormLoading,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: CustomButton(
                  text: 'Back To Login',
                  outlineButton: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
