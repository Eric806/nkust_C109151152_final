import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../obj/Data.dart';
import '../../obj/User.dart';

class registerWidget extends StatefulWidget{
  final change;
  registerWidget({Key? key, this.change}) : super(key: key);
  @override
  _registerWidget createState() => _registerWidget();
}

class _registerWidget extends State<registerWidget>{
  bool validname= false;
  bool validpwd = false;
  bool validpwd2 = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController pwd2Controller = TextEditingController();
  String errText = "";
  @override
  Widget build(BuildContext context){
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '註冊',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 80,
            ),
          ),
          SizedBox(height: 15,),
          TextField(
            controller: nameController,
            enableSuggestions: false,
            decoration: InputDecoration(
              labelText: '帳號',
              errorText: validname? "不得為空":null,
              labelStyle: TextStyle(
                color: Colors.black,
              ),
            ),
            style: TextStyle(fontSize: 22),
          ),
          SizedBox(height: 15,),
          TextField(
            controller: pwdController,
            enableSuggestions: false,
            obscureText: true,
            decoration: InputDecoration(
                labelText: '密碼',
                errorText: validpwd? "不得為空":null,
                labelStyle: TextStyle(
                  color: Colors.black,
                )
            ),
            style: TextStyle(fontSize: 22),
          ),
          SizedBox(height: 15,),
          TextField(
            controller: pwd2Controller,
            enableSuggestions: false,
            obscureText: true,
            decoration: InputDecoration(
                labelText: '密碼確認',
                errorText: validpwd2? "不得為空":null,
                labelStyle: TextStyle(
                  color: Colors.black,
                )
            ),
            style: TextStyle(fontSize: 22),
          ),
          SizedBox(height: 15,),
          Text(
            errText,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  TextButton(
                    onPressed: (){
                      widget.change("login");
                    },
                    child: Text(
                      '返回',
                      style: const TextStyle(
                        color: Colors.purple,
                        fontSize: 16.0,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                child: Text("註冊", style: TextStyle(color: Colors.white),),
                onPressed:() => registerBtn(widget),
                style: ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 20)),
              ),
            ],
          )
        ]
    );
  }
  void registerBtn(registerWidget widget){
    String name = nameController.text;
    String pwd = pwdController.text;
    String pwd2 = pwd2Controller.text;
    name.isEmpty ? validname = true : validname = false;
    pwd.isEmpty ? validpwd = true : validpwd = false;
    pwd2.isEmpty ? validpwd2 = true : validpwd2 = false;
    if(validname || validpwd || validpwd2){
      setState(() {});
    }
    else{
      if(pwd != pwd2){
        setState(() {
          errText = "您輸入的兩個密碼並不相符，請再試一次。";
          pwdController.clear();
          pwd2Controller.clear();
        });
      }
      else {
        setState(() {
          errText = "申請註冊中...";
        });
        if (user.token == -1) {
          showDialog(
              context: context,
              builder: (_) => guestRegDialog(_, context)
          );
        } else {
          User.register(name, pwd).then((code) {
            if (code == 0) {
              Fluttertoast.showToast(msg: "註冊成功");
              Navigator.pushReplacementNamed(context, 'enter');
            } else {
              setErrText(code);
            }
          });
        }
      }
    }
  }

  Widget guestRegDialog(_,BuildContext context){
    String name = nameController.text;
    String pwd = pwdController.text;
    return AlertDialog(
      title: Text("資料同步"),
      content: Text("是否將離線帳號的資料同步到此帳號？"),
      actions: [
        TextButton(
          child: Text("取消"),
          onPressed: () {
            Navigator.pop(_);
          },
        ),
        TextButton(
          child: Text("跳過同步"),
          onPressed: () {
            User.register(name, pwd).then((code) {
              if (code == 0) {
                Data.clear();
                Navigator.pop(_);
                Fluttertoast.showToast(msg: "註冊成功");
                Navigator.pushReplacementNamed(context, 'enter');
              } else {
                setErrText(code);
                Navigator.pop(_);
              }
            });
          },
        ),
        TextButton(
          child: Text("同步"),
          onPressed: () {
            User.register(name, pwd).then((code) {
              if (code == 0) {
                Navigator.pop(_);
                Fluttertoast.showToast(msg: "註冊成功，資料開始同步...");
                Navigator.pushReplacementNamed(context, 'enter');
              } else {
                setErrText(code);
                Navigator.pop(_);
              }
            });
          },
        ),
      ],
    );
  }
  void setErrText(int code){
    if (code == 1) {
      setState(() {
        errText = "帳號已存在";
      });
    } else if (code == 2) {
      setState(() {
        errText = "伺服器錯誤，請稍後再試";
      });
    } else if (code == 3) {
      setState(() {
        errText = "連線錯誤，請稍後再試";
      });
    }
  }
}