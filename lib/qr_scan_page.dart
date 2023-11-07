import 'package:biometric_app/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QRScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  String qrCode = 'Unknown';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('QR page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Scan Result',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '$qrCode',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 72),
              TextButton(onPressed: scanQRCode, child: Text('Scan QR code')),
              TextButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const AuthScreen()));
              }, child: Text('Biometrics page'))
            ],
          ),
        ),
      );

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
      });

      final uri = Uri.parse(qrCode);

      // Extract the clientId and sessionId from query parameters
      final clientId = uri.queryParameters['clientId'];
      final sessionId = uri.queryParameters['sessionId'];

      print(clientId); print(sessionId);
      final Uri url = Uri.parse(qrCode);
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $uri');
    }
      //if qr code scanned -> move to the biometrics page 
      
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }
}