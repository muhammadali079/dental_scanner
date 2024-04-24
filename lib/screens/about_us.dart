import 'package:flutter/material.dart';
import 'package:dental_scanner/utils/custom_navbar.dart';
import 'package:dental_scanner/utils/custom_footer.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Column(
        children: [
          CustomNavBar(activeRoute: '/about'),
          Expanded(
            child: Center(
              child: Text('About Us Screen Content'),
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}