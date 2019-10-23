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
        title: Text(
          'Exchange Rates',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.grey.shade800,
            height: MediaQuery.of(context).size.height * 0.71,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Text(
                  '1 $convertFrom',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 64,
                  ),
                ),
                Text(
                  '=',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 64,
                  ),
                ),
                Text(
                  '$result  $convertTo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 64,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.29,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[                          //covert from
                        Icon(Icons.keyboard_arrow_up,),
                        Container(
                          child: !Platform.isAndroid ? DropdownButton(
                            isExpanded: true,
                            elevation: 5,
                            onChanged: (selectedCurrency) {
                              convertFrom = selectedCurrency;
                              result = (latestDataMap['rates'][convertTo] /
                                  latestDataMap['rates'][convertFrom])
                                  .toStringAsFixed(2);
                              setState(() {});
                            },
                            items: currencyList.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text("            $value  "),
                              );
                            }).toList(),
                            value: convertFrom,
                          ) :
                          CupertinoPicker.builder(
                            itemExtent: 40,
                            childCount: currencyList.length,
                            itemBuilder: (context, index) {
                              print("index in IOS picker is $index");
                              return Text(currencyList[index]);
                            },
                            onSelectedItemChanged: (index) {
                              convertFrom = currencyList[index];
                              result = (latestDataMap['rates'][convertTo] /
                                  latestDataMap['rates'][convertFrom])
                                  .toStringAsFixed(2);
                              setState(() {});
                            },
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down)
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        //covert to
                        Icon(Icons.keyboard_arrow_up,),
                        Container(
                          height: 75,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Platform.isAndroid
                                ? DropdownButton(
                              isExpanded: true,
                              elevation: 5,
                              onChanged: (selectedCurrency) {
                                convertFrom = selectedCurrency;
                                result = (latestDataMap['rates'][convertTo] /
                                    latestDataMap['rates'][convertFrom])
                                    .toStringAsFixed(2);
                                setState(() {});
                              },
                              items: currencyList.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text("            $value  "),
                                );
                              }).toList(),
                              value: convertTo,
                            )
                                : CupertinoPicker.builder(
                                    itemExtent: 40,
                                    childCount: currencyList.length,
                                    itemBuilder: (context, index) {
                                      print("index in IOS picker is $index");
                                      return Text(currencyList[index]);
                                    },
                                    onSelectedItemChanged: (index) {
                                      convertTo = currencyList[index];
                                      result = (latestDataMap['rates']
                                                  [convertTo] /
                                              latestDataMap['rates']
                                                  [convertFrom])
                                          .toStringAsFixed(2);
                                      setState(() {});
                                    },
                                  ),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
