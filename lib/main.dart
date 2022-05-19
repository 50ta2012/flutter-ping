import 'dart:async';

import 'package:flutter/material.dart';
// import 'dart:io';
import 'package:dart_ping/dart_ping.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Ping';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  // const MyCustomForm({super.key});

  TextEditingController inputValueController = TextEditingController();

  void pingIp(String ip) async {
    var ping = Ping(ip, count: 5);
    var result = await ping.stream.first;
    // pingResult = result.toString();
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: TextField(
            controller: inputValueController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: '輸入 IP',
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            child: ElevatedButton(
              onPressed: () => {pingIp(inputValueController.text)},
              child: const Text('PING'),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          child: Text(""),
        ),
      ],
    );
  }
}
