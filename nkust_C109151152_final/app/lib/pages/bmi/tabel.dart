import 'package:flutter/material.dart';
import '../../obj/Body.dart';
import '../../obj/Data.dart';

class tabel extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return ListView(
      padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
      children: [
        table()
      ],
    );
  }
}

class table extends StatefulWidget{
  @override
  _table createState() => _table();
}

class _table extends State<table>{
  List<DataRow> row = [];
  @override
  Widget build(BuildContext context){
    if(row.isEmpty) {
      dataRow();
    }
    return DataTable(
        border: TableBorder(
          top: BorderSide(width: 2),
          left: BorderSide(width: 2),
          right: BorderSide(width: 2),
          bottom: BorderSide(width: 2),
        ),
        columnSpacing: 30.0,
        columns: [
          DataColumn(label: Text('身高', style: TextStyle(fontSize: 18),)),
          DataColumn(label: Text('體重', style: TextStyle(fontSize: 18),)),
          DataColumn(label: Text('BMI', style: TextStyle(fontSize: 18),)),
          DataColumn(label: Text('日期', style: TextStyle(fontSize: 18),)),
        ],
        rows: row
    );
  }

  void dataRow(){
    row = [];
    for(int i = Data.data.length - 1; i >= 0; i--){
      Body d = Data.data[i];
      String h = d.height.toStringAsFixed(1);
      String w = d.weight.toStringAsFixed(1);
      String bmi = d.bmi.toStringAsFixed(2);
      String date = d.date;
      List<String> datex = date.split("\n");
      int index = Data.data.length - 1 - i;
      row.add(DataRow.byIndex(
          color: MaterialStateProperty.all<Color>(i % 2 == 1 ? Color.fromARGB(255, 226, 226, 226) : Colors.white),
          cells: [
            DataCell(Text(h, style: TextStyle(fontSize: 16),)),
            DataCell(Text(w, style: TextStyle(fontSize: 16))),
            DataCell(Text(bmi, style: TextStyle(color: getTextColor(d.bmi), fontSize: 16),)),
            DataCell(Text(date,)),
          ],
          index: index,
          onLongPress: () async{
            await showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text('是否刪除紀錄'),
                  content: Text('身高：$h\n體重：$w\nBMI：$bmi\n日期：${datex[0]}\n時間：${datex[1]}'),
                  actions: [
                    TextButton(
                      child: Text("取消"),
                      onPressed: () {
                        Navigator.pop(_);
                      },
                    ),
                    TextButton(
                      child: Text(
                        "刪除",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(_);
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              Data.delete(Data.data[i]).then((value) {
                                Navigator.pop(_);
                                dataRow();
                              });
                              return AlertDialog(
                                title: Text("刪除中..."),
                              );
                            }
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }
      ));
    }
    setState((){});
  }
  
  Color getTextColor(double bmi) {
    if (bmi < 18.5){
      return Colors.green;
    }else if(bmi < 24){
      return Colors.black;
    }else{
      return Colors.red;
    }
  }
}