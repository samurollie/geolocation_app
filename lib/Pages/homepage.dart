import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geo Locator"),
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Iniciar"),
          onPressed: () {
            Navigator.of(context).pushNamed('/location');
          },
        ),
      ),
    );
  }
}
