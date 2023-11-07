import 'dart:convert';

import 'package:biometric_app/authentication.dart';
import 'package:biometric_app/passed_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class AuthScreen extends StatefulWidget{
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreen();
  }
}

class _AuthScreen extends State<AuthScreen>{
  final _formKey=GlobalKey<FormState>();
  String email='';
  final emailController=TextEditingController();
  final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+", );

  bool _validateCredentials(){
    final _isValid=_formKey.currentState!.validate();
    if(!_isValid) return false;

    _formKey.currentState!.save();
    return true;
  }

  void APICall() async{
    try{
      var response = await http.post(
          Uri.parse('https://afa8-2401-4900-51f0-4b08-4864-26c1-6a2d-4b24.ngrok-free.app/api/auth/biometericLogin%27'),
          headers: {
            'Content-Type': 'application/json', 
          },
          body: jsonEncode({
            "clientId":"5f97f3f6lban5alh9o60vu23hk",
            "email":"shaurya.tomar@truminds.com",
            "sessionId":"454cf090-edca-4f70-be6d-65cd30f68baf",
        }),
      );
      print(response.statusCode);
      print(response.body);
    }
    catch(error){
      print(error);
    }
  }

  void dispose(){
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
              Text('Login to the app'),
              Text('use biometrics'),
              ElevatedButton.icon(onPressed: () async{
                await showDialog(
                  context: context, 
                  builder: (context){
                    return AlertDialog(
                      title: Text('Enter Email'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: emailController,
                              validator: (value){
                                if(value==null || value.isEmpty){return 'Email is required';}
                                else if(!emailRegex.hasMatch(value)) return 'Invalid email address';
                                return null;
                              },
                              onChanged: (value){
                                setState(() {
                                  email=value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(onPressed: (){Navigator.of(context).pop();}, child: 
                        Text('Cancel'),),
                        TextButton(onPressed: () async{
                          if(_validateCredentials()){
                            final enteredEmail=emailController.text;
                             Navigator.of(context).pop();
                            bool auth = await Authentication.authentication();
                            print('can authenticate: $auth');                        
                            
                            //if auth passed-> make the api call
                            if(auth){
                              APICall();
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const PassedScreen()));
                            }
                          }
                        }, 
                        child: Text('Authenticate'))
                      ],
                    );
                  });
              },icon: Icon(Icons.login), label: Text('Enter Email ID')),
            ],
          ),
        ),
      ),
    );
  }
}