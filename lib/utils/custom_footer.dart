import 'package:flutter/material.dart';
class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FooterItem(title: 'Privacy Policy', onTap: () {
            Navigator.pushReplacementNamed(context, '/privacy_policy');
          }),
          FooterItem(title: 'Terms and Conditions', onTap: () {
            Navigator.pushReplacementNamed(context, '/terms_and_conditions');
          }),
          FooterItem(title: 'Trademark', onTap: () {
            
          }),
        ],
      ),
    );
  }
}

class FooterItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  FooterItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        title,
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
    );
  }
}
