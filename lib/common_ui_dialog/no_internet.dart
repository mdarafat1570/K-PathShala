import 'package:flutter/material.dart';
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  MyStatefulWidgetState createState() => MyStatefulWidgetState();
}

class MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool _isToggled = false;

  void _toggleState() {
    setState(() {
      _isToggled = !_isToggled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateful Widget Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _isToggled ? 'State: ON' : 'State: OFF',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleState,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
              child: const Text('Toggle State'),
            ),
          ],
        ),
      ),
    );
  }
}
