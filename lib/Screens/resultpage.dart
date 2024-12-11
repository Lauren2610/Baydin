import 'package:baydin_flutter/Screens/homepage.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResultPage extends StatefulWidget {
  ResultPage({Key? key, required this.picurl}) : super(key: key);
  String picurl;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List _item = [];

  Future<void> readAnswerJson() async {
    print('Loading JSON...');
    try {
      final String response = await rootBundle.loadString('assets/data.json');
      print('JSON loaded successfully.');
      final data = jsonDecode(response);
      print('Decoding JSON...');
      if (data != null && data['Answers'] != null) {
        setState(() {
          _item = data['Answers'];
          print('_item: $_item');
        });
        print('Items loaded successfully. item = ${_item.length}');
      } else {
        print('Error: JSON data or items are null.');
      }
    } catch (e) {
      print('Error loading or decoding JSON: $e');
    }
  }

  @override
  void initState() {
    readAnswerJson();
    super.initState();
    print('picurl: ${widget.picurl}');
  }

  @override
  Widget build(BuildContext context) {
    var selectedAnswer = _item.firstWhere(
        (answer) => answer['AnswerImageUrl'] == widget.picurl,
        orElse: () => null);
    print('picurl: ${widget.picurl}');
    print('selectedAnswer: $selectedAnswer');

    return Scaffold(
      backgroundColor: const Color(0XFF1D246CFF),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  height: 400,
                  width: 500,
                  child: (widget.picurl == null)
                      ? CircularProgressIndicator()
                      : Image(
                          fit: BoxFit.fill,
                          image: AssetImage(widget.picurl),
                        ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              const Text('Ready...?'),
              const SizedBox(
                height: 50,
              ),
              const Text('.'),
              const SizedBox(
                height: 50,
              ),
              const Text('.'),
              const SizedBox(
                height: 50,
              ),
              const Text('.'),
              const SizedBox(
                height: 100,
              ),
              (selectedAnswer == null)
                  ? CircularProgressIndicator()
                  : Text('${selectedAnswer['AnswerDesp']}'),
            ],
          ),
        ),
      )),
    );
  }
}
