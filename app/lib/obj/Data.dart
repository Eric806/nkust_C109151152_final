import 'package:intl/intl.dart';
import 'Connect.dart';
import 'Body.dart';
import 'User.dart';
import 'DB.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Data{
  static List<Body> data = [];
  static late double targetWeight;
  static List<Body> _sync = [];
  static bool syncing = false;
  static bool needInit = true;
  static bool chartUpdate = true;

  static Future init() async{
    if(needInit) {
      targetWeight = await getTargetWeight();
      await DB.init();
      await load();
      needInit = false;
    }
    if(connecting && _sync.isNotEmpty && user.token != -1){
      upload();
    }
  }

  static void clear(){
    DB.clear();
    setTargetWeight(-1);
    data.clear();
    _sync.clear();
    needInit = true;
  }

  static Future load() async{
    List<Map<String, dynamic>> d = await DB.getBody();
    for(int i = 0; i < d.length; i++) {
      Body b = Body.withBmi(
          d[i]['height'], d[i]['weight'], d[i]['bmi'], d[i]['date'],
          d[i]['action']);
      if (d[i]['action'] != 2) {
        data.add(b);
      }
      if (d[i]['action'] != 0) {
        _sync.add(b);
      }
    }
  }

  static Future upload() async{
    if(!syncing && user.token != -1) {
      syncing = true;
      bool err = false;
      int errorTime = 0;
      while (connecting && _sync.isNotEmpty) {
        if (_sync[0].action == 1) {
          await Connect.enter(
              user.token, _sync[0].height, _sync[0].weight, _sync[0].date)
              .then((ok) {
            if (ok) {
              _sync[0].action = 0;
              DB.setDBAction(_sync[0]);
              _sync.removeAt(0);
            } else {
              err = true;
              errorTime += 1;
            }
          });
        } else if (_sync[0].action == 2) {
          await Connect.delete(user.token, _sync[0].date).then((ok) {
            if (ok) {
              DB.delete(_sync[0]);
              _sync.removeAt(0);
            } else {
              err = true;
              errorTime += 1;
            }
          });
        }
        if (err) {
          if (errorTime == 5) {
            break;
          }
        } else {
          errorTime = 0;
        }
      }
      syncing = false;
    }
  }

  static Future add(double height, double weight, double bmi) async{
    DateTime now = DateTime.now();
    String date = DateFormat("yyyy-MM-dd\nHH:mm:ss").format(now);
    Body b = Body.withBmi(height, weight, bmi, date, 1);
    DB.insert(b);
    data.add(b);
    _sync.add(b);
    chartUpdate = true;
    if(connecting && user.token != -1 && !syncing){
      await upload();
    }
  }

  static Future delete(Body b) async{
    chartUpdate = true;
    if(user.token == -1 || (b.action == 1 && !syncing)){
      data.remove(b);
      _sync.remove(b);
      DB.delete(b);
    }else{
      if(b.action == 0) {
        _sync.add(b);
      }
      b.action = 2;
      data.remove(b);
      DB.setDBAction(b);
      if(connecting && !syncing){
        upload();
      }
    }
  }

  static Future loadServerData(User u) async{
    await init();
    needInit = false;
    List? d = await Connect.getData(u.token);
    if(d != null){
      d.forEach((element) async{
        Body b = new Body(element[0], element[1], element[2], 0);
        data.add(b);
        await DB.insert(b);
      });
    }
  }

  static Future<double> getTargetWeight() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double w = prefs.getDouble('weight') ?? -1;
    return w;
  }

  static Future setTargetWeight(double weight) async {
    targetWeight = weight;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('weight', weight);
  }
}