import 'dart:convert';

import 'package:account_picker/account_picker.dart';
import 'package:biometric_app/authentication.dart';
import 'package:biometric_app/passed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:uni_links/uni_links.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreen();
  }
}

class _AuthScreen extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  final emailController = TextEditingController();
  final emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  String _clientId = '';
  String _sessionId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('_AuthScreen-> initState()');
    initUniLinks();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  Future<void> initUniLinks() async {
    try {
      final initialLink = await getInitialLink();
      print('_AuthScreen-> initUniLinks()');
      print('initialLink-> $initialLink');
      if (initialLink != null) {
        print('if not null-> $initialLink');
        var uri = Uri.parse(initialLink);
        uri.queryParameters.forEach((k, v) {
          print('key: $k - value: $v');
        });
        setState(() {
          _clientId = Uri.parse(initialLink).queryParameters['clientId']!;
          _sessionId = Uri.parse(initialLink).queryParameters['sessionId']!;
        });

        print('_clientId: $_clientId - _sessionId: $_sessionId');
      }
    } on PlatformException {
      print('Platform exception occured while getting initial link.');
    }
  }

  void updateEmail(String newEmail) {
    emailController.text = newEmail;
    setState(() {
      email = newEmail;
    });
  }

  bool _validateCredentials() {
    final _isValid = _formKey.currentState!.validate();
    if (!_isValid) return false;

    _formKey.currentState!.save();
    return true;
  }

  void APICall() async {
    try {
      var response = await http.post(
        Uri.parse('https://api.truiamassaas.link/dev/api/auth/biometericLogin'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "clientId": _clientId,
          "email": email,
          "sessionId": _sessionId,
        }),
      );
      if (response.statusCode == 200) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const PassedScreen()));
      } else {
        displayAlertDialog(context);
      }
      print(response.statusCode);
      print(response.body);
    } catch (error) {
      print(error);
    }
  }

  void displayAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Error"),
      content: const Text("Something went wrong! Authentication has failed."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TextButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const QrPage()));}, child: Text('Go to QR page')),
              // const Text('Login to the app'),
              // const Text('use biometrics'),
              ElevatedButton.icon(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Please enter your Email'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller: emailController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Email is required';
                                      } else if (!emailRegex.hasMatch(value)) {
                                        return 'Invalid email address';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onChanged: (value) {
                                      updateEmail(value);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      final EmailResult? emailResult =
                                          await AccountPicker.emailHint();
                                      print(emailResult);
                                      if (emailResult != null) {
                                        updateEmail(emailResult.email);
                                      } else {
                                        final String? phone =
                                            await AccountPicker.phoneHint();
                                        if (phone != null) {
                                          updateEmail(phone);
                                        }
                                      }
                                    },
                                    child: const Text('Select an account')),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                  onPressed: () async {
                                    if (_validateCredentials()) {
                                      final enteredEmail = emailController.text;
                                      Navigator.of(context).pop();
                                      bool auth =
                                          await Authentication.authentication();
                                      print('can authenticate: $auth');

                                      //if auth passed-> make the api call
                                      if (auth) {
                                        APICall();
                                        //   Navigator.of(context).push(
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               const PassedScreen()));
                                      }
                                    }
                                  },
                                  child: const Text('Authenticate'))
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Proceed To Authentication')),
            ],
          ),
        ),
      ),
    );
  }
}
