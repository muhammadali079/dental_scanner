import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:dental_scanner/utils/custom_navbar.dart';
import 'package:dental_scanner/utils/custom_footer.dart';

class ServicesScreen extends StatefulWidget {
  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  PlatformFile? _image;
  bool _isAnalyzing = false;
  List? _boundingBoxes = [];

  Future<void> _getImage() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile.files.first;
        _isAnalyzing = true;
      });
      await _simulateApiCall();
      await _storeImageAndBoxes();
    }
  }
      Future<void> _storeImageAndBoxes() async {
    try {
      String imageBase64 = base64Encode(_image!.bytes!);

     List<Map<String, dynamic>> flattenedBoxes = _boundingBoxes!
    .map((box) => {
          'x1': box[0],
          'y1': box[1],
          'x2': box[2],
          'y2': box[3],
          'objectType': box[4],
          'probability': box[5],
        })
    .toList();

    await FirebaseFirestore.instance.collection('analyses').add({
      'image': imageBase64,
      'boundingBoxes': flattenedBoxes,
      'timestamp': FieldValue.serverTimestamp(),
    });
      print('Image and boxes stored to Firebase');
    } catch (e) {
      print('Error storing image and boxes: $e');
    }
  }
  Future<void> _simulateApiCall() async {
    print('inside api function');
    try {
      final uri = Uri.parse('http://127.0.0.1:5000/detect');
      var request = http.MultipartRequest('POST', uri)
        ..files.add(http.MultipartFile.fromBytes(
          'image',
          _image!.bytes!,
          filename: _image!.name,
        ));

      var response = await request.send();

      if (response.statusCode == 200) {
        print("Status response 200");
        var decodedResponse = await response.stream.bytesToString();

        setState(() {
          _isAnalyzing = false;
          _boundingBoxes = jsonDecode(decodedResponse);
        });
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isAnalyzing = false;
      });
      //  final response = await http.get(Uri.parse('http://127.0.0.1:5000/check_connection'));
      //  if (response.statusCode == 200) {
      //     final jsonResponse = jsonDecode(response.body);
      //     setState(() {
      //       _status = jsonResponse['status'];
      //       _message = jsonResponse['message'];
      //     });
      //   } else {
      //     setState(() {
      //       _status = 'Error';
      //       _message = 'Failed to check connection';
      //     });
      //   }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome User'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              // Handle icon tap
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 70,
            color: Colors.grey[700],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomNavBar(activeRoute: '/services'),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Manage and Analyze Your Dental Health Easily',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _getImage,
                        child: Text('Upload Image'),
                      ),
                      SizedBox(height: 20),
                      _image != null
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.memory(
                                    _image!.bytes!), // Display X-ray image
                                ..._boundingBoxes!.map<Widget>((box) {
                                  return Positioned(
                                    left: box[0].toDouble(),
                                    top: box[1].toDouble(),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.5),
                                        border: Border.all(
                                          color: Colors.blue,
                                          width: 2,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Type: ${box[4]}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Confidence: ${box[5]}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Footer(),
    );
  }
}


// import 'dart:convert';
// import 'package:dental_scanner/utils/custom_footer.dart';
// import 'package:dental_scanner/utils/custom_navbar.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:file_picker/file_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ServicesScreen extends StatefulWidget {
//   @override
//   _ServicesScreenState createState() => _ServicesScreenState();
// }

// class _ServicesScreenState extends State<ServicesScreen> {
//   PlatformFile? _image;
//   bool _isAnalyzing = false;
//   List? _boundingBoxes = [];


//   GlobalKey globalKey = GlobalKey();

//   Future<void> _getImage() async {
//     FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();

//     if (pickedFile != null) {
//       setState(() {
//         _image = pickedFile.files.first;
//         _isAnalyzing = true;
//       });
//       await _simulateApiCall();
//     }
//   }

//   Future<void> _simulateApiCall() async {
//     print('inside api function');
//     try {
//       final uri = Uri.parse('http://127.0.0.1:5000/detect');
//       var request = http.MultipartRequest('POST', uri)
//         ..files.add(http.MultipartFile.fromBytes(
//           'image',
//           _image!.bytes!,
//           filename: _image!.name,
//         ));

//       var response = await request.send();

//       if (response.statusCode == 200) {
//         print("Status response 200");
//         var decodedResponse = await response.stream.bytesToString();

//         setState(() {
//           _isAnalyzing = false;
//           _boundingBoxes = jsonDecode(decodedResponse);
//         });

//         await Future.delayed(Duration(milliseconds: 200));
//         _storeImageAndBoxes();
//       } else {
//         throw Exception('Failed to load image');
//       }
//     } catch (e) {
//       print('Error: $e');
//       setState(() {
//         _isAnalyzing = false;
//       });
//     }
//   }
//   Future<void> _storeImageAndBoxes() async {
//     try {
//       String imageBase64 = base64Encode(_image!.bytes!);

//      List<Map<String, dynamic>> flattenedBoxes = _boundingBoxes!
//     .map((box) => {
//           'x1': box[0],
//           'y1': box[1],
//           'x2': box[2],
//           'y2': box[3],
//           'objectType': box[4],
//           'probability': box[5],
//         })
//     .toList();

//     await FirebaseFirestore.instance.collection('analyses').add({
//       'image': imageBase64,
//       'boundingBoxes': flattenedBoxes,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//       print('Image and boxes stored to Firebase');
//     } catch (e) {
//       print('Error storing image and boxes: $e');
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Welcome User'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.info),
//             onPressed: () {
//               // Handle icon tap
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Container(
//             height: 70,
//             color: Colors.grey[700],
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 CustomNavBar(activeRoute: '/services'),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SizedBox(height: 20),
//                       Text(
//                         'Manage and Analyze Your Dental Health Easily',
//                         style: TextStyle(
//                           fontSize: 36,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: _getImage,
//                         child: Text('Upload Image'),
//                       ),
//                       SizedBox(height: 20),
//                       _image != null
//                           ? _isAnalyzing
//                               ? Column(
//                                   children: [
//                                     CircularProgressIndicator(),
//                                     SizedBox(height: 10),
//                                     Text(
//                                       'Analyzing...',
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               : Column(
//                                   children: [
//                                     RepaintBoundary(
//                                       key: globalKey,
//                                       child: _renderImage(),
//                                     ),
//                                     SizedBox(height: 10),
//                                     Text(
//                                       "analyzed Successful",
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     SizedBox(height: 20),
//                                     Column(
//                                       children: _boundingBoxes!
//                                           .map<Widget>((box) {
//                                         return Container(
//                                           margin: EdgeInsets.symmetric(
//                                               vertical: 5),
//                                           padding: EdgeInsets.all(10),
//                                           decoration: BoxDecoration(
//                                             border: Border.all(
//                                               color: Colors.blue,
//                                               width: 2,
//                                             ),
//                                           ),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceEvenly,
//                                             children: [
//                                               Text(
//                                                 'Type: ${box[4]}',
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                               Text(
//                                                 'Confidence: ${box[5]}',
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       }).toList(),
//                                     ),
//                                   ],
//                                 )
//                           : Container(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Footer(),
//     );
//   }

//   Widget _renderImage() {
//     return kIsWeb && _image != null
//         ? Image.memory(_image!.bytes!)
//         : Container(); // Render image if available, otherwise empty container
//   }
// }
