import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Gamertag Generator'),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: UsernameGenerator(),
          ),
        ),
      ),
    );
  }
}

class UsernameGenerator extends StatefulWidget {
  @override
  _UsernameGeneratorState createState() => _UsernameGeneratorState();
}

class _UsernameGeneratorState extends State<UsernameGenerator> {
  String username = 'Enter a keyword and generate gamertag';
  String keyword = '';
  final keywordController = TextEditingController();
  final words = all.take(1000).toList();
  final previousUsernames = <String>[];

  void generateUsername() {
    var uuid = Uuid();
    var random = Random();

    setState(() {
      if (username != 'Enter a keyword and generate gamertag') {
        previousUsernames.add(username);
      }
      keyword = keywordController.text;
      var randomWord = words[random.nextInt(words.length)];
      var randomNumbers = uuid.v4().substring(0, 4);
      var components = [keyword, randomWord];
      components.shuffle();
      username = components.map((str) => str[0].toUpperCase() + str.substring(1)).join('') + randomNumbers;
    });
  }

  void goBack() {
    if (previousUsernames.isNotEmpty) {
      setState(() {
        username = previousUsernames.removeLast();
      });
    }
  }

  void copyUsername() {
    Clipboard.setData(ClipboardData(text: username));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2), // Added horizontal padding
          child: _buildKeywordTextField(),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Center(child: Text(username, style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.04))), // Centered username
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2), // Added horizontal padding
          child: _buildGenerateButton(),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2), // Added horizontal padding
          child: _buildCopyButton(),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2), // Added horizontal padding
          child: _buildGoBackButton(),
        ),
      ],
    );
  }

  CupertinoTextField _buildKeywordTextField() {
    return CupertinoTextField(
      controller: keywordController,
      placeholder: 'Enter keyword',
      padding: EdgeInsets.all(10), // Increased padding
    );
  }

  CupertinoButton _buildGenerateButton() {
    return CupertinoButton.filled(
      padding: EdgeInsets.all(10), // Reduced padding
      child: Text('Generate Gamertag'),
      onPressed: generateUsername,
    );
  }

  CupertinoButton _buildCopyButton() {
    return CupertinoButton.filled(
      padding: EdgeInsets.all(10), // Reduced padding
      child: Text('Copy Gamertag'),
      onPressed: copyUsername,
    );
  }

  CupertinoButton _buildGoBackButton() {
    return CupertinoButton.filled(
      padding: EdgeInsets.all(10), // Reduced padding
      child: Text('Go Back'),
      onPressed: goBack,
    );
  }

  @override
  void dispose() {
    keywordController.dispose();
    super.dispose();
  }
}