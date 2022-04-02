import 'dart:convert';
// import 'dart:html';
// import 'dart:math';
import 'dart:io';
import 'dart:math';

import 'package:secured_share_prefs/pizza.dart';
import 'package:http/http.dart' as http;

class HttpHelper{
  static final HttpHelper _httpHelper = HttpHelper._internal();
  HttpHelper._internal();
  factory HttpHelper(){
    return _httpHelper;
  }

  String authority= '66dqj.mocklab.io';
  String path = '/pizzalist';
  String postPath = '/pizza';
  String putPath = '/put_pizza';
  String delPath = '/pizza';


  // Creating a function to get json Data from Web Api
  Future<List<Pizza>?> getPizzaList()async{
    Uri url = Uri.https(authority, path);
    http.Response result = await http.get(url);
    if(result.statusCode == HttpStatus.ok){
      final jsonResponse = json.decode(result.body);
      List<Pizza> pizzas = jsonResponse.map<Pizza> ((i) {
        return Pizza.fromJson(i);
      }).toList();
      return pizzas;
    }else{
      return null;
    }
}

Future<String> postPizza(Pizza pizza)async{
    String post = jsonEncode(pizza.toJson());
    Uri url = Uri.https(authority, postPath);
    http.Response r= await http.post(url, body: post);
    return r.body;

}

Future<String> putPizza(Pizza pizza)async{
    String put = jsonEncode(pizza.toJson());
    Uri url = Uri.https(authority, putPath);
    http.Response r = await http.put(url, body: put);
    return r.body;
}
// DeletIng
Future<String> deletePizza(int? id)async{
  // String del = jsonEncode(pizza.toJson()); // we dont need this here actually
  Uri url = Uri.https(authority, delPath);
  http.Response r = await http.delete(url);
  return r.body;

}
}