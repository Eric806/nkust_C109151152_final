import 'package:flutter/material.dart';
import 'Plan.dart';
import 'package:nkust_c109151152_final/obj/DB.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';

class newPlanPage extends StatefulWidget{
  List<List<Plan>> plans;
  int week;
  int hour;
  int min;
  newPlanPage({required this.plans, this.week=0, this.hour=0, this.min=0});
  @override
  _newPlanPage createState() => _newPlanPage();
}

class _newPlanPage extends State<newPlanPage>{
  TextEditingController nameController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  bool validname=false;
  String? validDurationText;
  late int week, hour, min;

  @override
  void initState(){
    week=widget.week;
    hour=widget.hour;
    min=widget.min;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('新增計畫'),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '計畫名稱',
              style: TextStyle(
                  fontSize: 28
              ),
            ),
            TextField(
              controller: nameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: '名稱',
                errorText: validname ? "不得為空":null,
              ),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20,),
            Text(
              '時間',
              style: TextStyle(
                fontSize: 28
              ),
            ),
            SizedBox(height: 10,),
            DateTimePickerWidget(
              minDateTime: DateTime(2000, 1, 1, 0, 0),
              maxDateTime: DateTime(2000, 1, 7, 23, 59),
              initDateTime: DateTime(2000, 1, week+1, hour, min),
              dateFormat: "d/HH/mm",
              pickerTheme: DateTimePickerTheme(
                title: Row(
                  children: [
                    Expanded(
                        child:Center(
                          child: Text(
                            "星期",
                            style: TextStyle(
                              fontSize: 20
                            ),
                          ),
                        )
                    ),
                    Expanded(
                        child:Center(
                          child: Text(
                            "時",
                            style: TextStyle(
                                fontSize: 20
                            ),
                          ),
                        )
                    ),
                    Expanded(
                        child:Center(
                          child: Text(
                            "分",
                            style: TextStyle(
                                fontSize: 20
                            ),
                          ),
                        )
                    ),
                  ],
                )
              ),
              onChange: (DateTime time, List l){
                min=l[4];
                hour=l[3];
                week=l[2];
              },
            ),
            SizedBox(height: 20,),
            Text(
              '持續時間',
              style: TextStyle(
                  fontSize: 28
              ),
            ),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '時間',
                helperText: '分鐘',
                errorText: validDurationText,
              ),
              style: TextStyle(fontSize: 20),
            ),
            Expanded(child: Container(
              alignment: Alignment.bottomRight,
              child: TextButton(
                child: Text(
                  "保存",
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),
                onPressed: saveBtn,
              ),
            )),
          ],
        ),
      ),

    );
  }

  void saveBtn() {
    nameController.text.isEmpty ? validname = true : validname = false;
    durationController.text.isEmpty ? validDurationText="不可為空":validDurationText=null;
    if(!durationController.text.isEmpty){
      int duration = int.parse(durationController.text);
      if(duration<=0) {
        validDurationText="時間必須大於0";
      }else{
        String name = nameController.text;
        Plan p = new Plan(name, week, hour, min, duration);
        if (p.start.week != p.end.week) {
          validDurationText = "時間超出範圍，不可跨日";
        }
      }
    }
    if (validname || validDurationText!=null) {
      setState(() {});
    } else {
      String name = nameController.text;
      int duration = int.parse(durationController.text);
      Plan p = new Plan(name, week, hour, min, duration);
      widget.plans[week].add(p);
      DB.insertPlan(p);
      Navigator.pop(context);
    }
  }
}