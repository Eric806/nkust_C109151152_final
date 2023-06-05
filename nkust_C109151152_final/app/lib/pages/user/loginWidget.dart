import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../obj/Connect.dart';
import '../../obj/Data.dart';
import '../../obj/User.dart';

class loginWidget extends StatefulWidget{
  Function(String) change;
  loginWidget({required this.change});
  @override
  _loginWidget createState() => _loginWidget();
}

class _loginWidget extends State<loginWidget>{
  bool validname= false;
  bool validpwd = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  String errText = "";
  @override
  Widget build(BuildContext context){
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/pic/logo.png'),
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
                    onPressed: () => widget.change("register"),
                    child: Text(
                      '註冊帳號',
                      style: const TextStyle(
                        color: Colors.purple,
                        fontSize: 16.0,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => guestLogin(context),
                    child: Text(
                      '離線登入',
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
                child: Text("登入", style: TextStyle(color: Colors.white),),
                onPressed:() => loginBtn(context),
                style: ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 20)),
              ),
            ],
          )
        ]
    );
  }
  void loginBtn(BuildContext context){
    String name = nameController.text;
    String pwd = pwdController.text;
    name.isEmpty ? validname = true : validname = false;
    pwd.isEmpty ? validpwd = true : validpwd = false;
    if(validname || validpwd){
      setState(() {});
    }
    else{
      if(user.token == -1){
        showDialog(
            context: context,
            builder: (_) => guestLoginDialog(_, context)
        );
      } else {
        setState(() {
          errText = "登入中...";
        });
        User.login(name, pwd).then((code) async{
          if (code == 0) {
            Fluttertoast.showToast(msg: "登入成功");
            await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  Data.loadServerData(user).then((value) => Navigator.pop(_));
                  return AlertDialog(
                    title: Text('同步資料中...'),
                    content: Text('請勿中斷連線或關閉程式'),
                  );
                }
            );
            Navigator.pushReplacementNamed(context, 'enter');
          } else {
            setErrText(code);
          }
        });
      }
    }
  }

  void guestLogin(BuildContext context){
    user.set("遊客", -1, true);
    Navigator.pushReplacementNamed(context, 'enter');
  }

  Widget guestLoginDialog(_, BuildContext context){
    String name = nameController.text;
    String pwd = pwdController.text;
    return AlertDialog(
      title: Text("警告"),
      content: Text("登入後會將目前資料全部刪除，是否確認？"),
      actions: [
        TextButton(
          child: Text("取消"),
          onPressed: () {
            Navigator.pop(_);
          },
        ),
        TextButton(
          child: Text("登入"),
          onPressed: () {
            User.login(name, pwd).then((code) async{
              if (code == 0) {
                Fluttertoast.showToast(msg: "登入成功");
                Navigator.pop(_);
                Data.clear();
                await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      Data.loadServerData(user).then((value) =>Navigator.pop(_));
                      return AlertDialog(
                        title: Text('同步資料中...'),
                        content: Text('請勿中斷連線或關閉程式'),
                      );
                    }
                );
                Navigator.pushReplacementNamed(context, 'enter');
              } else {
                setErrText(code);
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
        errText = "帳號或密碼錯誤";
        pwdController.clear();
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