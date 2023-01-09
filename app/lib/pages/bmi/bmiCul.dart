import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nkust_c109151152_final/obj/Connect.dart';
import '../../obj/Data.dart';
import '../../obj/User.dart';

class bmiCul extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return ListView(
      padding:EdgeInsets.only(top:10, left:10, right:10),
      children: <Widget> [
        bmiWidget(context),
        Container(
          child: Image(
            image: AssetImage("assets/pic/bmi.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

class bmiWidget extends StatefulWidget{
  late BuildContext father;
  bmiWidget(BuildContext context){
    father = context;
  }
  @override
  _bmiWidget createState() => _bmiWidget();
}

class _bmiWidget extends State<bmiWidget>{
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  double bmi = 0;
  bool validateh = false, validatew = false, validBmi = true;
  bool culBtnPause = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        color:Colors.grey.shade300,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '請輸入身高',
                  hintText: 'cm',
                  errorText: validateh ? "不得為空":null,
                  icon: Icon(Icons.trending_up),
                ),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '請輸入體重',
                  hintText: 'Kg',
                  errorText: validatew ? "不得為空":null,
                  icon: Icon(Icons.trending_down),
                ),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: getColor(bmi),
                    child: Text(
                      validBmi ? "":"您的BMI值=${bmi.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: Text("計算", style: TextStyle(color: Colors.white),),
                    onPressed: () => culBtnPause ? Null : culBtn(),
                    style: ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 20)),
                  ),
                ]
              ),
            ]
        )
    );
  }

  void culBtn() async{
    culBtnPause = true;
    Future.delayed(Duration(seconds: 2)).then((value) => culBtnPause = false);
    calculateBMI();
  }

  void calculateBMI() {
    heightController.text.isEmpty ? validateh=true:validateh=false;
    weightController.text.isEmpty ? validatew=true:validatew=false;
    validBmi = validateh || validatew;
    if (!validateh && !validatew) {
      double height = double.parse(heightController.text);
      double weight = double.parse(weightController.text);
      double h = height / 100;
      setState(() {
        bmi = weight / (h * h);
      });
      Data.add(height, weight, bmi).then((value){
        checkConnect();
      });
    }
    else {
      setState(() {});
      showDialog(context: context, builder:(context) {
        return AlertDialog(title:Text("警告"),
          content:Text("身高體重不得為空!"),
          actions:<Widget>[
            TextButton(onPressed: ()=>Navigator.pop(context),
              child: Text("了解"),)
          ],);
      });
    }
  }

  Color getColor(double bmi){
    if(bmi < 18.5){
      return Color.fromARGB(255, 200, 255, 188);
    }else if(bmi < 24){
      return Color.fromARGB(255, 254, 255, 153);
    }else if(bmi < 27){
      return Color.fromARGB(255, 255, 219, 105);
    }else if(bmi < 30){
      return Color.fromARGB(255, 255, 154, 136);
    }else if(bmi < 35){
      return Color.fromARGB(255, 255, 84, 93);
    }else{
      return Color.fromARGB(255, 234, 0, 0);
    }
  }
  void checkConnect(){
    if(!noConnectShowed && !connecting && user.token != -1){
      noConnectShowed = true;
      ScaffoldMessenger.of(context).showSnackBar(noConnect());
    }
  }
  bool noConnectShowed = false;
  SnackBar noConnect(){
    return SnackBar(
      content: Text('沒有網路連線，請檢查你的網路'),
      duration: Duration(days: 1),
      action: SnackBarAction(
        label: '重試',
        onPressed: (){
          Fluttertoast.showToast(msg: "連線中...");
          Connect.tryConnect().then((connect){
            if(connect){
              Fluttertoast.showToast(msg: "連線成功");
              noConnectShowed = false;
              Data.upload();
            }else{
              Fluttertoast.showToast(msg: "連線失敗，請稍後再試");
              ScaffoldMessenger.of(context).showSnackBar(noConnect());
            }
          });
        },
      ),
    );
  }
}