import 'package:flutter/material.dart';
import 'Plan.dart';
import 'planList.dart';
import 'planTable.dart';
import 'newPlanPage.dart';
import 'package:nkust_c109151152_final/obj/DB.dart';

class planPage extends StatefulWidget{
  @override
  _planPage createState() => _planPage();
}

class _planPage extends State<planPage>{
  late List<List<Plan>> plans;
  late List tabs;

  Future setPlans()async{
    plans=List.generate(7, (index) => []);
    tabs=[
      planTable(plans: plans,),
      planList(plans: plans,)
    ];
    List data=await DB.getPlan();
    for(int i=0; i<data.length; i++){
      Map now=data[i];
      Plan p=Plan(now['name'], now['week'], now['hour'], now['min'], now['duration']);
      plans[now['week']].add(p);
    }
  }

  int _currentindex = 0;
  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: setPlans(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Scaffold(
          appBar: AppBar(
            title: Text('計畫表'),
          ),
          body: snapshot.connectionState==ConnectionState.done?tabs[_currentindex]:Center(child:CircularProgressIndicator()),
          floatingActionButton: FloatingActionButton(
            onPressed: ()async{
              await Navigator.push(context, MaterialPageRoute(builder: (_)=>newPlanPage(plans: plans,)));
              setState((){});
            },
            child: Icon(Icons.add),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.blue,
            selectedItemColor: Colors.white,
            selectedFontSize: 18.0,
            unselectedFontSize: 14.0,
            iconSize: 30.0,
            currentIndex: _currentindex,
            items:[
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_on),
                label: '時間表',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: '清單',
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentindex=index;
              });
            },
          ),
        );
      },
    );
  }
}