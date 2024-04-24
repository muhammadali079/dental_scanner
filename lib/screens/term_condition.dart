import 'package:flutter/material.dart';
import 'package:dental_scanner/utils/custom_navbar.dart';
import 'package:dental_scanner/utils/custom_footer.dart';

class TermsConditionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Condition'),
      ),
      body: Column(
        children: [
          CustomNavBar(activeRoute: '/terms'),
          Expanded(
            child: Center(
              child: Text('Terms and condition Screen Content'),
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}