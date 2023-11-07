import 'package:flutter/material.dart';

class PassedScreen extends StatefulWidget{
  const PassedScreen({super.key});

  @override
  State<PassedScreen> createState() => _PassedScreenState();
}

class _PassedScreenState extends State<PassedScreen> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('auth passed')),
    );
  } 
}