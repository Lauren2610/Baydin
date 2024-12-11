import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'resultpage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _item = [];

  Future<void> readQuestionJson() async {
    print('Loading JSON...');
    try {
      final String response = await rootBundle.loadString('assets/data.json');
      print('JSON loaded successfully.');
      final data = jsonDecode(response);
      print('Decoding JSON...');
      if (data != null && data['Questions'] != null) {
        setState(() {
          _item = data['Questions'];
        });
        print('Items loaded successfully. item = ${_item.length}');
      } else {
        print('Error: JSON data or items are null.');
      }
    } catch (e) {
      print('Error loading or decoding JSON: $e');
    }
  }

  Widget _buildQuestionDescription(String fullDescription) {
    const int maxCharacters = 500; // Adjust this based on your needs

    if (fullDescription.length <= maxCharacters) {
      return Text(fullDescription);
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(fullDescription.substring(0, maxCharacters)),
          TextButton(
            onPressed: () {
              _showFullDescriptionDialog(fullDescription);
              // Handle "See More" button tap (e.g., navigate to a new screen)
            },
            child: Text('See More'),
          ),
        ],
      );
    }
  }

  void _showFullDescriptionDialog(String fullDescription) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(fullDescription),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    readQuestionJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tarot',
          style: TextStyle(fontFamily: 'Jacques_Francois_Shadow'),
        ),
        backgroundColor: Color(0XFF265B64FF),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Handle the person icon press here
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Hello'),
              accountEmail: Text('laurent@example.com'),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
            SizedBox(
              height: 550,
            ),
            GestureDetector(
              child: Container(
                height: 50,
                color: Colors.red,
                child: Center(
                  child: Text(
                    'Log Out',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: const Color(0XFF1D246CFF),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: _item.isEmpty
                ? CircularProgressIndicator() //: or some other loading indicator

                : ListView.builder(
                    itemCount: _item.length,
                    itemBuilder: (context, index) {
                      var question = _item[index];

                      // Calculate file index for the current question
                      int fileIndex = index + 1;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExpansionTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    question['QuestionName'],
                                  ),
                                ),
                              ],
                            ),
                            initiallyExpanded: false,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: _buildQuestionDescription(
                                    question['QuestionDesp']),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                                crossAxisCount: 2,
                              ),
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                String picUrl({int? fIndex, int? pIndex}) {
                                  return 'articles/$fIndex/$pIndex.jpg';
                                }

                                // Calculate photo index for the current image
                                int photoIndex = index + 1;

                                return AspectRatio(
                                    aspectRatio: 1.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: (Image.asset("Image/") == null)
                                            ? CircularProgressIndicator()
                                            : GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ResultPage(
                                                                  picurl: picUrl(
                                                                      fIndex:
                                                                          fileIndex,
                                                                      pIndex:
                                                                          photoIndex))));
                                                },
                                                child: Container(
                                                    color: Colors.blueAccent,
                                                    child:
                                                        // Image.asset(
                                                        //   'Image/$fileIndex/$photoIndex.jpg',
                                                        //   fit: BoxFit.fill,
                                                        // ),
                                                        Image.asset(
                                                      picUrl(
                                                          fIndex: fileIndex,
                                                          pIndex: photoIndex),
                                                      fit: BoxFit.fill,
                                                    )),
                                              ),
                                      ),
                                    ));
                              },
                            ),
                          ),
                          const SizedBox(height: 100.0),
                        ],
                      );
                    },
                  )),
      ),
    );
  }
}
