// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/constants.dart';
import 'package:food_delivery_app/screens/forgot_password_page.dart';
import 'package:food_delivery_app/screens/register_page.dart';
import 'package:food_delivery_app/widgets/custom_button.dart';
import 'package:food_delivery_app/widgets/custom_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

//Login with user account
  Future<String?> _loginAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail, password: _loginPassword);
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
      _loginFormLoading = true;
    });
    //Run the login account method
    String? _loginFeedback = await _loginAccount();
    //if string is not null, we got error while creating
    if (_loginFeedback != null) {
      _alertDialogBuilder(_loginFeedback);
      //Set the form to regular(not loading) state
      setState(() {
        _loginFormLoading = false;
      });
    }
  }

//create default Form Loading State
  bool _loginFormLoading = false;
  //Form Input Field Values
  String _loginEmail = '';
  String _loginPassword = '';
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
                  'Welcome User,\nLogin to your account',
                  textAlign: TextAlign.center,
                  style: Constants.boldHeading,
                ),
              ),
              Column(
                children: [
                  CustomInput(
                    hintText: 'Email',
                    onChanged: (value) {
                      _loginEmail = value;
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
                      _loginPassword = value;
                    },
                    onSubmitted: (value) {
                      _submitForm();
                    },
                    focusNode: _passwordFocusNode,
                  ),
                  CustomButton(
                    text: 'Login',
                    outlineButton: false,
                    onPressed: () {
                      _submitForm();
                    },
                    isLoading: _loginFormLoading,
                  ),
                  GestureDetector(
                    child: Text(
                      'Forgot password ?',
                      style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage())),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: CustomButton(
                  text: 'Create New Account',
                  outlineButton: true,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
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
