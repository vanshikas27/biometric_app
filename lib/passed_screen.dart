import 'package:flutter/material.dart';

import 'button_widget.dart';

class PassedScreen extends StatefulWidget {
  const PassedScreen({super.key});

  @override
  State<PassedScreen> createState() => _PassedScreenState();
}

class _PassedScreenState extends State<PassedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thankyou!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            ButtonWidget(
              text: 'Authentication has been completed successfully.',
              // style: TextStyle(fontSize: 24),
              onClicked: () => {},
            ),
          ],
        ),
      ),
    );
    //   body: Container(
    //     decoration: const BoxDecoration(
    //       image: DecorationImage(
    //         image: AssetImage("assets/img/bg.jpg"),
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //     child: null /* add child content here */,
    //   ),
    //   appBar: AppBar(title: const Text('Authentication has been completed successfully.')),
    // );
  }
}
