import 'dart:convert';
import 'dart:typed_data';

import 'package:dental_scanner/utils/custom_footer.dart';
import 'package:dental_scanner/utils/custom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body:
       Column(
         children: [
           CustomNavBar(activeRoute: '/history'),
           Expanded(
             child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('analyses').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final docs = snapshot.data?.docs ?? [];
                
                  
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = (docs[index].data() as Map<String, dynamic>);
                    final imageURL = data['image'];
                    List<int> bytes = base64.decode(imageURL);
                    final timestamp = data['timestamp'];
                    final boxes = data['boundingBoxes'] as List<dynamic>;
                    return ListTile(
                      title: Stack(
                        children: [
                          Image.memory(Uint8List.fromList(bytes)),
                          ...boxes.map<Widget>((box) {
                            final left = box['x1'] as double;
                            final top = box['y1'] as double;
                            final width = (box['x2'] as double) - left;
                            final height = (box['y2'] as double) - top;
                            return Positioned(
                              left: left,
                              top: top,
                              width: width,
                              height: height,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red, width: 2),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                      subtitle: Text('Timestamp: $timestamp'),
                    );
                  },
                );
                }
              
                 ),
           ),
         ],
       ),
        bottomNavigationBar: Footer(), 
    );
  }
}
