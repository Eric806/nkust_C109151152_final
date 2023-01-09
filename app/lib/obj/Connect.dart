import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

bool connecting = false;

class Connect{
  static String host = 'http://10.1.1.13:8000';

  static Future<int> login(String name, String pwd) async {
    String url = "$host/login";
    var data = utf8.encode('$name\n$pwd');
    try {
      var res = await http.post(
        Uri.parse(url),
        body: data,
      ).timeout(Duration(seconds: 3));
      if (res.statusCode == 200) {
        return int.parse(res.body);
      }
      else {
        return -2;
      }
    }on TimeoutException catch(e){
      connecting = false;
      return -3;
    }
  }

  static Future<int> register(String name, String pwd) async {
    String url = "$host/register";
    var data = utf8.encode('$name\n$pwd');
    try {
      var res = await http.post(
        Uri.parse(url),
        body: data,
      ).timeout(Duration(seconds: 3));
      if (res.statusCode == 200) {
        return int.parse(res.body);
      }
      else{
        return -2;
      }
    }on TimeoutException catch (e){
      connecting = false;
      return -3;
    }
  }

  static Future<bool> delete(int token, String time) async {
    String url = "$host/delete";
    var data = utf8.encode('$time');
    var header = {'token': '$token'};
    try {
      var res = await http.post(
        Uri.parse(url),
        body: data,
        headers: header,
      ).timeout(Duration(seconds: 3));
      if (res.statusCode == 200) {
        return true;
      }else{
        return false;
      }
    }on TimeoutException catch (e){
      connecting = false;
      return false;
    }
  }

  static Future<bool> enter(int token, double height, double weight, String time) async {
    String url = "$host/enter";
    var data = utf8.encode('$height\n$weight\n$time');
    var header = {'token': '$token'};
    try {
      var res = await http.post(
        Uri.parse(url),
        body: data,
        headers: header,
      ).timeout(Duration(seconds: 5));
      if (res.statusCode == 200) {
        return true;
      }else{
        return false;
      }
    }on TimeoutException catch (e){
      connecting = false;
      return false;
    }
  }

  static Future<List?> getData(int token) async {
    String url = "$host/data";
    var header = {'token': '$token'};
    try {
      var res = await http.get(
        Uri.parse(url),
        headers: header,
      ).timeout(Duration(seconds: 10));
      if (res.statusCode == 200) {
        List data = jsonDecode(res.body);
        return data;
      }else{
        return null;
      }
    }on TimeoutException catch(e){
      connecting = false;
      return null;
    }
  }

  static Future<bool> tryConnect() async {
    String url = "$host/try";
    try {
      var res = await http.get(
        Uri.parse(url),
      ).timeout(Duration(seconds: 3));
      if (res.statusCode == 200) {
        connecting = true;
      }
    }on TimeoutException catch (e){
      connecting = false;
    }
    return connecting;
  }
}