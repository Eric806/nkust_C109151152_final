import 'package:flutter/material.dart';
import 'package:timetable_view/timetable_view.dart';
import 'newPlanPage.dart';
import 'Plan.dart';
import 'package:nkust_c109151152_final/obj/DB.dart';

class planTable extends StatefulWidget{
  planTable({required this.plans});
  List<List<Plan>> plans;
  @override
  _planTable createState() => _planTable();
}

class _planTable extends State<planTable>{
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return TimetableView(
            laneEventsList: laneEventsList(),
            onEventTap: onEventTap,
            onEmptySlotTap: onEmptySlotTap,
            timetableStyle: TimetableStyle(
              laneWidth: constraints.maxWidth/8,
              laneHeight: constraints.maxHeight/25,
              timeItemWidth: constraints.maxWidth/8,
              timeItemHeight: constraints.maxHeight/25,
              visibleTimeBorder: false,
            ),
          );
        }
    );
  }

  List<LaneEvents> laneEventsList(){
    List<LaneEvents> laneEvents=[];
    List d=["一", "二", "三", "四", "五", "六", "日"];
    List<List<Plan>> p=widget.plans;
    for(int i=0; i<p.length; i++){
      LaneEvents l=LaneEvents(
          lane: Lane(name: d[i], laneIndex: i),
          events: []
      );
      for(int j=0; j<p[i].length; j++){
        l.events.add(
          TableEvent(
              title: p[i][j].name,
              eventId: j,
              laneIndex: i,
              startTime: TableEventTime(hour: p[i][j].start.hour, minute: p[i][j].start.min),
              endTime: TableEventTime(hour: p[i][j].end.hour, minute: p[i][j].end.min),
              padding: EdgeInsets.all(1),
          )
        );
      }
      laneEvents.add(l);
    }
    return laneEvents;
  }

  void onEmptySlotTap(int laneIndex, TableEventTime start, TableEventTime end) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => newPlanPage(
              plans: widget.plans,
              week: laneIndex,
              hour: start.hour,
              min: start.minute,
            )
        )
    );
    setState(() {});
  }

  void onEventTap(TableEvent event) async{
    Plan p=widget.plans[event.laneIndex][event.eventId];
    await showDialog(context: context, builder: (_){
      return AlertDialog(
        title: Text(
          "詳細內容",
          style: TextStyle(
            fontSize: 24,
            color: Colors.blueAccent,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "計畫名稱： ${p.name}",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
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
        actions: [
          TextButton(
            child: Text("關閉"),
            onPressed: () {
              Navigator.pop(_);
            },
          ),
          TextButton(
            child: Text(
              "刪除此計畫",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onPressed: () async {
              setState(() {
                DB.deletePlan(p);
                widget.plans[event.laneIndex].remove(p);
              });
              Navigator.pop(_);
            },
          ),
        ],
      );
    });
  }
}

