import 'package:flutter/material.dart';
import 'package:nkust_c109151152_final/obj/Connect.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:page_transition/page_transition.dart';
import '../../obj/User.dart';
import '../../obj/Data.dart';
import '../../obj/Connect.dart';
import '../bmi/bmiPage.dart';

class enterPage extends StatefulWidget {
  enterPage({Key? key}) : super(key: key);
  @override
  State<enterPage> createState() => _enterPage();
}

class _enterPage extends State<enterPage> {

  bool isFinished=false;

  @override
  Widget build(BuildContext context) {
    if(!connecting && user.token != -1) {
      Connect.tryConnect();
    }
    Future dataInit = Data.init();
    return Scaffold(
       body: Container(
         width: double.infinity,
           decoration: BoxDecoration(
               image: DecorationImage(
                 image: AssetImage('assets/pic/bg2.jpeg'),
                 fit: BoxFit.cover,
               )
           ),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Spacer(flex: 2,),
               Text(
                 '歡迎',
                 style: TextStyle(
                   color: Colors.yellowAccent,
                   fontSize: 36,
                 ),
               ),
               Text(
                 user.name,
                 style: TextStyle(
                   color: Colors.yellowAccent,
                   fontSize: 60,
                 ),
               ),
               Spacer(flex: 2,),
               Padding(
                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                 child: SwipeableButtonView(
                   buttonText: "滑動進入",
                   buttontextstyle: TextStyle(
                       fontSize: 30,
                       color: Colors.white
                   ),
                   buttonWidget: Container(
                     child: Icon(
                       Icons.arrow_forward_ios_rounded,
                       color: Colors.grey,
                     ),
                   ),
                   activeColor: Color(0xff3398F6),
                   isFinished: isFinished,
                   onWaitingProcess: () {
                     dataInit.then((value){
                       setState(() {
                         isFinished=true;
                       });
                     });
                     },
                   onFinish: () async {
                     setState(() {
                       isFinished=false;
                     });
                     await Navigator.pushReplacement(
                         context,
                         PageTransition(
                             type: PageTransitionType.fade,
                             child: bmiPage()
                         )
                     );
                   },
                 ),
               ),
             ],
           )
       )
    );
  }
}