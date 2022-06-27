// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/constants.dart';
import 'package:food_delivery_app/widgets/custom_button.dart';
import 'package:food_delivery_app/widgets/custom_input.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String _forgotEmail = '';
  Future _passwordReset() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _forgotEmail);
  }

  // Future<AuthStatus> resetPassword({required String email}) async {
  //   await _auth
  //       .sendPasswordResetEmail(email: email)
  //       .then((value) => _status = AuthStatus.successful)
  //       .catchError((e) => _status = AuthExceptionHandler.handleAuthException(e));
  //   return _status;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(top: 24),
                child: Text(
                  'Welcome User,\nReset your password via Email',
                  textAlign: TextAlign.center,
                  style: Constants.boldHeading,
                ),
              ),
              Column(
                children: [
                  CustomInput(
                    hintText: 'Email',
                    onChanged: (value) {
                      _forgotEmail = value;
                    },
                  ),
                  CustomButton(
                    text: 'Reset password',
                    outlineButton: false,
                    onPressed: () {
                      setState(() {
                        _passwordReset();
                      });
                      if (_forgotEmail != '') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Password reset email sent!'),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Invalid email to reset password'),
                        ));
                      }
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //   content: Text('Password reset email sent!'),
                      // ));
                    },
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
