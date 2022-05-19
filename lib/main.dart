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
        body: const MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final inputValueController = TextEditingController();
  var myResult = "";

  var ping = Ping("");

  void setMyResult(String result) {
    setState(() {
      myResult = result;
    });
  }

  void pingIp(String ip) async {
    ping = Ping(ip, interval: 1);
    var result = "";

    ping.stream.listen((event) {
      result += '${event.toString()}\n';
      setMyResult(result.toString());
    });
  }

  void stopPing() async {
    await ping.stop();
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
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: () => {pingIp(inputValueController.text)},
                    child: const Text('PING')),
                const SizedBox(width: 5),
                ElevatedButton(
                  onPressed: () => {stopPing()},
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: const Text('STOP'),
                ),
              ],
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(myResult),
        ),
      ],
    );
  }
}
