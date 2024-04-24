import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final String activeRoute;

  const CustomNavBar({required this.activeRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: Colors.grey[700],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          NavBarItem(title: 'Home', onTap: () {
            Navigator.pushReplacementNamed(context, '/home');
          }, isActive: activeRoute == '/home'),
          NavBarItem(title: 'Services', onTap: () {
            Navigator.pushReplacementNamed(context, '/services');
          }, isActive: activeRoute == '/services'),
          NavBarItem(title: 'History', onTap: () {
            Navigator.pushReplacementNamed(context, '/history');
          }, isActive: activeRoute == '/history'),
          NavBarItem(title: 'About Us', onTap: () {
            Navigator.pushReplacementNamed(context, '/about');
          }, isActive: activeRoute == '/about'),
        ],
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isActive;

  NavBarItem({required this.title, required this.onTap, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: isActive ? Border(bottom: BorderSide(color: const Color.fromARGB(255, 250, 17, 0), width: 2)) : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 24,
            color:  Colors.white,
          ),
        ),
      ),
    );
  }
}

