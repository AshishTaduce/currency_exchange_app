import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'network_helper.dart';

void main() {
  runApp(MaterialApp(
    home: CurrencyExchange(),
  ));
}

class CurrencyExchange extends StatefulWidget {
  @override
  _CurrencyExchangeState createState() => _CurrencyExchangeState();
}

String convertFrom = 'INR';
String convertTo = 'USD';
bool fetchedDataMap = false;
List<String> currencyList = ['USD'];

CurrencyDataMap currentData = CurrencyDataMap();
Map latestDataMap;
String result = '1';

class _CurrencyExchangeState extends State<CurrencyExchange> {
  @override
  void initState() {
    fetchLatestDataMap();
    fetchedDataMap = true;
    super.initState();
  }

  void fetchLatestDataMap() async {
    latestDataMap = await currentData.latestMap();
    //now lets automate all the values of drop down menu
    List<String> x = populateButtonList(latestDataMap);
    currencyList = x;
    fetchedDataMap = true;
    setState(() {});
  }

  List<String> populateButtonList(Map x) {
    Map subMap = x['rates'];
    print('Inside Populate list ');
    return subMap.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Exchange Rates', style: TextStyle(color: Colors.white, fontSize: 24),),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.grey.shade800,
              height: MediaQuery.of(context).size.height * 0.71,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start ,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Text('1 $convertFrom', textAlign: TextAlign.center, style: TextStyle(
                    color: Colors.orange, fontSize: 64,
                  ),),
                  Text('=',textAlign: TextAlign.center, style: TextStyle(
                    color: Colors.orange, fontSize: 64,
                  ),),
                  Text('$result  $convertTo', textAlign: TextAlign.center, style: TextStyle(
                    color: Colors.orange, fontSize: 64,
                  ),),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('From',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                            fontSize: 32,color: Colors.black
                          ),
                          ),
                        ),
                        //covert from selected currency
                        DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(color: Colors.blueGrey)),
                          child: Container(
                            width: 120,
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: DropdownButton(
                                elevation: 5,
                                onChanged: (selectedCurrency) {
                                  convertFrom = selectedCurrency;
                                  fetchLatestDataMap();
                                  print('from $selectedCurrency');
                                  result = (latestDataMap['rates'][convertTo] /
                                          latestDataMap['rates'][convertFrom])
                                      .toStringAsFixed(2);
                                  setState(() {});
                                },
                                items: currencyList
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: convertFrom,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('To',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 32,color: Colors.black
                            ),),
                        ),
                        //covert to  selected currency
                        DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                      border: Border.all(color: Colors.blueGrey)),
                          child: Container(
                            width: 120,
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Platform.isAndroid ? DropdownButton(
                                elevation: 5,
                                onChanged: (selectedCurrency) {
                                  convertTo = selectedCurrency;
                                  print('to $selectedCurrency');
                                  result = (latestDataMap['rates'][convertTo] /
                                      latestDataMap['rates'][convertFrom])
                                      .toStringAsFixed(2);
                                  setState(() {});
                                },
                                items: currencyList
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: convertTo,
                              ) :
                              CupertinoPicker(
                                magnification: 1.5,
                                backgroundColor: Colors.black87,
                                children: <Widget>[
                                  Text(
                                    "TextWidget",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                                itemExtent: 50, //height of each item
                                looping: true,
                                onSelectedItemChanged: (selectedCurrency) {
                                  convertTo = '$selectedCurrency';
                                  print('to $selectedCurrency');
                                  result = (latestDataMap['rates'][convertTo] /
                                      latestDataMap['rates'][convertFrom])
                                      .toStringAsFixed(2);
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
