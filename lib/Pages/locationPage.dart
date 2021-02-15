import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  StreamSubscription<Position> listener;
  // Future<List<Position>> futuraLista;
  var listPosition = new List<Position>(10);
  int i = 0;
  // Position position;

  @override
  void initState() {
    super.initState();
    _verifyPermission();
    getPositions();
  }

  void _verifyPermission() async {
    bool isActive;
    LocationPermission permission;

    isActive = await Geolocator.isLocationServiceEnabled();
    if (!isActive) {
      return Future.error("Serviço de localização desativado!");
    } else {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            "Permissão Negada para sempre, não é possível obter a sua localização!");
      } else if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          return Future.error('Permissão negada (valor atual: $permission).');
        }
      }
    }
  }

  void getPositions() {
    this.listener = Geolocator.getPositionStream(
      intervalDuration: Duration(seconds: 3),
    ).listen((Position position) {
      print(
        position == null
            ? 'Unknown'
            : position.latitude.toString() +
                ', ' +
                position.longitude.toString(),
      );
      this.listPosition[i % 10] = position;
      setState(() {
        i++;
      });
    });

    /* this.futuraLista =
        Geolocator.getPositionStream(intervalDuration: Duration(seconds: 3))
            .toList()
            .then((value) => this.verdadeiraLista = value);
    print(futuraLista);
    for (int i = 0; i < 10; i++) {
      print(verdadeiraLista);
    } */
  }

  Widget mostrarPosicoes() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text((this.listPosition[index] == null)
              ? "Unknown"
              : this.listPosition[index].toString()),
        );
      },
    );
  }

  Widget posicoes(Position position) {
    return Card(
      child: ListTile(
        title: Text(
          position.latitude.toString() + ', ' + position.longitude.toString(),
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Icon(
          Icons.map_outlined,
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text("PARAR"),
              onPressed: () {
                this.listener.cancel();
                print(this.listPosition);
                print("PAROU!!!");
                Navigator.of(context).pop();
              },
            ),
            Text(
              "Últimas 10 coordenadas:",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Flexible(
              child: mostrarPosicoes(),
            ),
          ],
        ),
      ),
    );
  }
}
