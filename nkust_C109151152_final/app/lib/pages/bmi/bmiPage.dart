import 'package:flutter/material.dart';
import 'package:nkust_c109151152_final/pages/plan/planPage.dart';
import 'bmiCul.dart';
import 'chart.dart';
import 'tabel.dart';
import 'package:nkust_c109151152_final/obj/User.dart';
import 'package:nkust_c109151152_final/obj/Data.dart';

class bmiPage extends StatefulWidget {
  @override
  State<bmiPage> createState() => _bmiPage();
}

class _bmiPage extends State<bmiPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final tabs=[
    bmiCul(),
    chart(),
    tabel()
  ];

  int _currentindex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('線上BMI紀錄分析器'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () => _key.currentState!.openDrawer(),
        ),
      ),
      drawer: Drawer(
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
              child:Image(
                image: AssetImage('assets/pic/logo.png'),
                fit: BoxFit.fill,
              ),
            ),
            Text(
              "帳號：${user.name}",
              style: TextStyle(
                fontSize: 20
              ),
            ),
            SizedBox(height: 10,),
            DrawerItem(
              icon: Icons.access_time,
              title: "計畫表",
              color: Colors.blueAccent,
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>planPage()));
              },
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  user.token == -1 ?
                    DrawerItem(
                      icon: Icons.power_settings_new,
                      title: "登入或註冊",
                      color: Colors.blueAccent,
                      onTap: (){
                        Navigator.pushReplacementNamed(context, 'login');
                      },
                    ) :
                    DrawerItem(
                      icon: Icons.power_settings_new,
                      title: "登出",
                      color: Colors.red,
                      onTap: (){
                        showDialog(
                            context: context,
                            builder: (_) => logoutDialog(_, context)
                        );
                      },
                    ),
                ],
              ),
            )
          ]
        )
      ),
      body: tabs[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        selectedFontSize: 18.0,
        unselectedFontSize: 14.0,
        iconSize: 30.0,
        currentIndex: _currentindex,
        items:[
          BottomNavigationBarItem(icon: Icon(Icons.calculate_outlined),
            label: 'bmi計算',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add_chart_outlined),
            label: '圖表',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined),
            label: '紀錄',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentindex=index;
          });
          },
      ),
    );
  }
  Widget logoutDialog(_,BuildContext context){
    return AlertDialog(
      title: Text("是否登出"),
      content: Text("登出後如有未同步的資料將會全部消失，是否確認登出？"),
      actions: [
        TextButton(
          child: Text(
            "取消",
            style: TextStyle(
                color: Colors.red,
            ),
          ),
          onPressed: () {
            Navigator.pop(_);
          },
        ),
        TextButton(
          child: Text("登出"),
          onPressed: () {
            user.clear();
            Data.clear();
            Navigator.pop(_);
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
      ],
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Color color;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon, size: 28,
        color: color,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          color: color,
        ),
      ),
      onTap: onTap,
    );
  }
}