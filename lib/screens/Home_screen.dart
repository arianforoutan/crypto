import 'package:crypto/data/constant/constants.dart';
import 'package:crypto/data/model/crypto.dart';

import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'coin_list_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Color.fromARGB(255, 1, 3, 23),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/1414.jpg'),
              ),
              SizedBox(
                height: 50,
              ),
              SpinKitDancingSquare(
                color: Color.fromARGB(255, 202, 174, 47),
                size: 80,
              ),
            ],
          )),
    );
  }

  void getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> CryptoList = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoinListScreen(
          CryptoList: CryptoList,
        ),
      ),
    );
  }
}
