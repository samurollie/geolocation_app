import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  StreamSubscription<Position> posicao_atual;
  Position position;

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

  void getPositions() async {
    this.posicao_atual = Geolocator.getPositionStream(
      intervalDuration: Duration(seconds: 3),
    ).listen((Position position) {
      print(
        position == null
            ? 'Unknown'
            : position.latitude.toString() +
                ', ' +
                position.longitude.toString(),
      );
      setState(() {
        this.position = position;
      });
    });
  }

  Widget mostrarPosicoes() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(
              this.position.latitude.toString() +
                  ', ' +
                  this.position.longitude.toString(),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        );
      },
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
              onPressed: () async {
                this.posicao_atual.cancel();
                print("PAROU!!!");
                Navigator.of(context).pop();
              },
            ),
            Text(
              "Ultimas 10 coordenadas:",
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
