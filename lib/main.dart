import 'package:flutter/material.dart';
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
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text(appTitle),
          ),
          body: const MyCustomForm()),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final inputValueController = TextEditingController();
  var myResult = "";

  void setMyResult(String result) {
    setState(() {
      myResult = result;
    });
  }

  var ping = Ping("");

  bool _isButtonDisabled = false;

  void setButtonDisabled(bool isDisAbled) {
    setState(() {
      _isButtonDisabled = isDisAbled;
    });
  }

  void pingIp(String ip) async {
    setButtonDisabled(true);
    ping = Ping(ip, interval: 1);
    var result = "";
    ping.stream.listen((event) {
      if(event.response == null){
        setButtonDisabled(false);
      }
      result += '${event.toString()}\n';
      setMyResult(result.toString());
      _scrollToEnd();
    });
  }

  void stopPing() async {
    setButtonDisabled(false);
    await ping.stop();
  }

  final ScrollController _scrollController = ScrollController();

  _scrollToEnd() async {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
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
              hintText: 'Input IP or URL ...',
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: () => {
                          _isButtonDisabled
                              ? null
                              : pingIp(inputValueController.text)
                        },
                    style: _isButtonDisabled
                        ? ElevatedButton.styleFrom(primary: Colors.blue[200])
                        : null,
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
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  child: Text(myResult)),
            ))
      ],
    );
  }
}
