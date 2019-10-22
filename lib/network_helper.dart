import 'dart:convert';
import 'package:http/http.dart';

class CurrencyDataMap {
  String url = 'https://api.exchangeratesapi.io/latest';

  Future<Map> latestMap() async {
    print('reached here step 1');
    Response response = await get('https://api.exchangeratesapi.io/latest');
    if (response.statusCode == 200) {
      print("response 200");
    }
    Map<String, dynamic> currenciesMap = jsonDecode(response.body);
    print('Got Json MAp');
    return currenciesMap;
  }
}