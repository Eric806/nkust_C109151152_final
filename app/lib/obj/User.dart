import 'package:shared_preferences/shared_preferences.dart';
import 'Connect.dart';


User user = new User(name: "", token: -2, isLogin: false);

class User{
  String name;
  int token;
  bool isLogin;
  User({required this.name, required this.token, required this.isLogin});

  void save() async{
    if(token >= -1){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', name);
      prefs.setInt('token', token);
      prefs.setBool('isLogin', isLogin);
    }
  }
  void set(String name, int token, bool isLogin){
    this.name = name;
    this.token = token;
    this.isLogin = isLogin;
    save();
  }

  void clear(){
    set("", -2, false);
    save();
  }

  static Future<User> load() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name') ?? "";
    int token = prefs.getInt('token') ?? -2;
    bool isLogin = prefs.getBool('isLogin') ?? false;
    return User(name: name, token: token, isLogin: isLogin);
  }

  static Future<int> login(String name, String pwd) async{
    int id = await Connect.login(name, pwd);
    if(id >= 0){  //登入成功
      user.set(name, id, true);
      return 0;
    }else if(id == -1){ //登入錯誤
      return 1;
    }else if(id == -2){  //伺服器錯誤
      return 2;
    }else{  //連線錯誤
      return 3;
    }
  }

  static Future<int> register(String name, String pwd) async{
    int id = await Connect.register(name, pwd);
    if(id >= 0){  //註冊成功
      user.set(name, id, true);
      return 0;
    }else if(id == -1){ //帳號已存在
      return 1;
    }else if(id == -2){
      return 2; //伺服器錯誤
    }else{
      return 3; //連線錯誤
    }
  }
}