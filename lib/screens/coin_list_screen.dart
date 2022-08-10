import 'dart:ui';

import 'package:crypto/data/constant/constants.dart';
import 'package:crypto/data/model/crypto.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

class CoinListScreen extends StatefulWidget {
  CoinListScreen({Key? key, this.CryptoList}) : super(key: key);
  List<Crypto>? CryptoList;
  @override
  State<CoinListScreen> createState() => _CoinListScreenState();
}

class _CoinListScreenState extends State<CoinListScreen> {
  List<Crypto>? CryptoList;
  bool isSearchLoading = false;
  @override
  void initState() {
    super.initState();
    CryptoList = widget.CryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('crypto'),
            Icon(Icons.currency_bitcoin_outlined),
            Text('کریپتو'),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 16, 32, 51),
      ),
      backgroundColor: Color.fromARGB(255, 16, 32, 51),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 50,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    onChanged: (value) {
                      _filterList(value);
                    },
                    decoration: InputDecoration(
                        hintText: 'نام  رمز   ارز   را   وارد   کنید',
                        hintStyle:
                            TextStyle(fontWeight: FontWeight.bold, color: back),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              width: 15,
                              style: BorderStyle.none,
                              color: Color.fromARGB(255, 85, 86, 87)),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 141, 163, 224)),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isSearchLoading,
              child: Text(
                '...در حال بروز رسانی',
                style: TextStyle(
                  color: Color.fromARGB(255, 241, 195, 143),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: Color.fromARGB(255, 85, 86, 87),
                backgroundColor: Color.fromARGB(255, 241, 195, 143),
                onRefresh: (() async {
                  List<Crypto> fereshData = await _getData();
                  setState(() {
                    CryptoList = fereshData;
                  });
                }),
                child: ListView.builder(
                  itemCount: CryptoList!.length,
                  itemBuilder: (context, index) {
                    return _getListTileItem(CryptoList![index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getIconChangePercent(double percentchange) {
    return percentchange <= 0
        ? Icon(
            Icons.trending_down,
            size: 30,
            color: redColor,
          )
        : Icon(
            Icons.trending_up,
            size: 30,
            color: greencolor,
          );
  }

  Color _getIconChangeText(double percentchange) {
    return percentchange <= 0 ? redColor : greenColor;
  }

  Widget _getListTileItem(Crypto crypto) {
    return ListTile(
      title: Text(
        crypto.name,
        style: TextStyle(
          color: Color.fromARGB(255, 241, 195, 143),
          fontSize: 22,
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            crypto.symbol,
            style: TextStyle(
              color: Color.fromARGB(255, 85, 86, 87),
            ),
          ),
        ],
      ),
      leading: SizedBox(
        width: 25.0,
        child: Center(
          child: Text(
            crypto.rank.toString(),
            style: TextStyle(
              color: Color.fromARGB(255, 85, 86, 87),
            ),
          ),
        ),
      ),
      trailing: SizedBox(
        width: 120.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  crypto.priceUsd.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 141, 163, 224),
                  ),
                ),
                Text(
                  crypto.changePercent24hr.toStringAsFixed(2),
                  style: TextStyle(
                    color: _getIconChangeText(crypto.changePercent24hr),
                  ),
                ),
              ],
            ),
            _getIconChangePercent(crypto.changePercent24hr),
          ],
        ),
      ),
    );
  }

  Future<List<Crypto>> _getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> CryptoList = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();
    return CryptoList;
  }

  Future<void> _filterList(String enteredKeyword) async {
    List<Crypto> cryptoResultList = [];
    if (enteredKeyword.isEmpty) {
      setState(() {
        isSearchLoading = true;
      });
      var result = await _getData();
      setState(() {
        CryptoList = result;
        isSearchLoading = false;
      });
      return;
    }

    cryptoResultList = CryptoList!.where((element) {
      return element.name.toLowerCase().contains(enteredKeyword);
    }).toList();

    setState(() {
      CryptoList = cryptoResultList;
    });
  }
}
