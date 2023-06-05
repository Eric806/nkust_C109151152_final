import 'package:flutter/material.dart';
import 'pages/bmi/bmiPage.dart';
import 'pages/user/loginPage.dart';
import 'pages/user/enterPage.dart';
import 'pages/plan/planPage.dart';
import 'pages/plan/newPlanPage.dart';
import 'obj/User.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: loadingPage(),
      routes: <String, WidgetBuilder>{
        'login': (BuildContext context) => loginPage(),
        'enter': (BuildContext context) => enterPage(),
        'bmi': (BuildContext context) => bmiPage(),
      },
    );
  }
}

//初始化頁面
class loadingPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    startPage(context);
    return Container(
      color: Color.fromARGB(255, 51, 51, 51),
    );
  }
  Future startPage(BuildContext context) async{
    user = await User.load();
    if(user.isLogin){
      Navigator.pushReplacementNamed(context, 'enter');
    }
    else{
      Navigator.pushReplacementNamed(context, 'login');
    }
  }
}

