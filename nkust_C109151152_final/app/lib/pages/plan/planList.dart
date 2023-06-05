import 'package:flutter/material.dart';
import 'Plan.dart';
import 'package:nkust_c109151152_final/obj/DB.dart';

class planList extends StatefulWidget{
  List<List<Plan>> plans;
  planList({required this.plans});
  @override
  _planList createState() => _planList();
}

class _planList extends State<planList>{
  @override
  Widget build(BuildContext context){
    return ListView(
      padding: EdgeInsets.fromLTRB(10, 15, 10, 70),
      children: planWidgets(),
    );
  }

  List<Widget> planWidgets(){
    List<List<Plan>> p = widget.plans;
    List<Widget> w=[];
    for(int i=0; i<p.length; i++){
      for(int j=0; j<p[i].length; j++){
        w.add(planWidget(p: p[i][j], index: i, remove: removePlan,));
      }
    }
    return w;
  }

  void removePlan(Plan p, int index)async{
    await showDialog(context: context, builder: (_){
      return AlertDialog(
        title: Text(
          "確認刪除？",
          style: TextStyle(
              fontSize: 24
          ),
        ),
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
              setState(() {
                DB.deletePlan(p);
                widget.plans[index].remove(p);
              });
              Navigator.pop(_);
            },
          ),
        ],
      );
    });
  }
}

class planWidget extends StatelessWidget{
  Plan p;
  int index;
  void Function(Plan, int) remove;
  planWidget({
    required this.p,
    required this.index,
    required this.remove,
  });

  @override
  Widget build(BuildContext context){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 20,
          )
        ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 8,),
                Text(
                  "周次：　　 星期${p.start.getWeek()}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  "開始時間： ${p.start.getHour()}:${p.start.getMin()}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  "結束時間： ${p.end.getHour()}:${p.end.getMin()}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  "持續時間： ${p.duration}分鐘",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
              alignment: Alignment.bottomRight,
              child: TextButton(
                child: Text(
                  "移除",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
                onPressed: (){
                  remove(p, index);
                },
              )
          ),
        ],
      )
    );
  }
}