import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /* title: Icon(
          Icons.map_outlined,
        ), */
        title: Text("Geo Locator"),
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Iniciar"),
          onPressed: () {},
        ),
      ),
    );
  }
}
