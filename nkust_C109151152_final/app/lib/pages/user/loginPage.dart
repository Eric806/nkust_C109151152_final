import 'package:flutter/material.dart';
import 'registerWidget.dart';
import 'loginWidget.dart';
import '../../obj/User.dart';

class loginPage extends StatefulWidget{
  @override
  _loginPage createState() => _loginPage();
}

class _loginPage extends State<loginPage>{
  Widget? child;
  _loginPage(){
    child = loginWidget(change: (text)=>setChild(text));
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 100),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/pic/bg1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: child,
      ),
    );
  }

  setChild(String page){
    setState(() {
      if(page == "login"){
        child = loginWidget(change: (text)=>setChild(text),);
      }
      else if(page == "register"){
        child = registerWidget(change: (text)=>setChild(text));
      }
    });
  }
}

