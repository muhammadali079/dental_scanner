import 'package:flutter/material.dart';
import 'package:dental_scanner/utils/custom_navbar.dart';
import 'package:dental_scanner/utils/custom_footer.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy and Policy'),
      ),
      body: Column(
        children: [
          CustomNavBar(activeRoute: '/policy'),
          Expanded(
            child: Center(
              child: Text('Privacy and Policy Screen Content'),
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}