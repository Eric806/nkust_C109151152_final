import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../obj/Data.dart';

class chart extends StatefulWidget{
  @override
  _chart createState() => _chart();
}

class _chart extends State<chart>{
  static bool needUpdate = true;
  List<sElement> sData = [];
  double avg = 0;
  List<charts.Series<sElement, int>> seriesList = [];
  TextEditingController weightController = TextEditingController();
  late double weight;
  late double height;
  late double suggestWeight;
  @override
  Widget build(BuildContext context) {
    Data.chartUpdate = true;
    if(Data.data.length > 1) {
      if (Data.chartUpdate) {
        initData();
        initSeries();
        Data.chartUpdate = false;
      }
    }
    int amount = Data.data.length > 10 ? 10: Data.data.length;
    return Data.data.length > 1 ? Padding(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('當前身高：${height}cm'),
          Row(
            children: [
              Container(
                child: Text("期望體重：", style: TextStyle(fontSize: 16,),),
              ),
              SizedBox(width: 150,child: TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Kg(建議:${suggestWeight.round()})',
                ),
                style: TextStyle(fontSize: 20),
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  Data.setTargetWeight(weightController.text.isEmpty || double.parse(weightController.text) <= 0? -1 : double.parse(weightController.text));
                  setState(() {});
                },
              ),),
            ],
          ),
          SizedBox(height: 15,),
          Container(
              height: 240,
              child: charts.LineChart(
                seriesList,
                behaviors: [
                  charts.ChartTitle(
                    '近期體重',
                    behaviorPosition: charts.BehaviorPosition.top,
                  ),
                  charts.ChartTitle(
                    '最近${amount}次體重變化',
                    behaviorPosition: charts.BehaviorPosition.bottom,
                  ),
                  charts.SeriesLegend(
                      position: charts.BehaviorPosition.bottom,
                      cellPadding: new EdgeInsets.only(right: 4,bottom: 0),
                      showMeasures: true,
                      defaultHiddenSeries: Data.targetWeight < 0 ? ['目標體重'] : null,
                      measureFormatter: (num? value){
                        return value == null ? '_' : '${value}k';
                      }
                  )
                ],
                primaryMeasureAxis: charts.NumericAxisSpec(
                    tickProviderSpec: charts.BasicNumericTickProviderSpec(
                      zeroBound: false,
                      desiredMinTickCount: 5,
                    )
                ),
                domainAxis: charts.NumericAxisSpec(
                    tickProviderSpec: charts.BasicNumericTickProviderSpec(
                      zeroBound: false,
                      desiredMinTickCount: amount,
                    )
                ),
                customSeriesRenderers: [
                  charts.PointRendererConfig(
                    customRendererId: 'customPoint'
                  )
                ],
              )
          ),
          Expanded(
            child:Container(
                width: double.infinity,
                color: Colors.grey.shade300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '您最近的體重${changeText(weight - avg)}',
                      style: TextStyle(
                          fontSize: 25
                      ),
                    ),
                    Text(
                      Data.targetWeight < 0 ? "": getTargetText(weight, Data.targetWeight),
                      style: TextStyle(
                          fontSize: 25
                      ),
                    ),
                    Text(
                      '建議每日攝取${getCalories()}大卡',
                      style: TextStyle(
                          fontSize: 25
                      ),
                    ),
                  ],
                )
            ),
          )
        ],
      ),
    ) :
    Center(child: Text('請先輸入兩筆以上的資料', style: TextStyle(fontSize: 24,),),);
  }

  void initData(){
    height = Data.data[Data.data.length - 1].height;
    weight = Data.data[Data.data.length - 1].weight;
    double h = height/100;
    suggestWeight = 21.25 * h * h;
    weightController.text = Data.targetWeight > 0 ? Data.targetWeight.toString() : "";
  }
  void initSeries(){
    setData();
    setSeriesList();
  }

  void setData(){
    sData.clear();
    double total = 0;
    int i;
    int lend = Data.data.length;
    int elementLen = lend >= 10 ? 10 : lend;
    for(i = 0; i < Data.data.length; i++){
      if(i < 10){
        sData.add(sElement(elementLen - i, Data.data[Data.data.length - 1 - i].weight));
      }
      if(i != 0){
        total += Data.data[Data.data.length - 1 - i].weight;
      }
      if(i == 30){
        break;
      }
    }
    avg = total / (i - 1);
  }

  void setSeriesList() {
    seriesList = [
      new charts.Series<sElement, int>(
          id: "",
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          measureFn: (sElement s, _) => s.weight,
          domainFn: (sElement s, _) => s.id,
          data: sData
      )..setAttribute(charts.rendererIdKey, 'customPoint'),
      new charts.Series<sElement, int>(
          id: "體重",
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          measureFn: (sElement s, _) => s.weight,
          domainFn: (sElement s, _) => s.id,
          data: sData
      ),
      new charts.Series<sElement, int>(
          id: "目標體重",
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          measureFn: (sElement s, _) => Data.targetWeight,
          domainFn: (sElement s, _) => s.id,
          data: sData
      ),
    ];
  }

  String changeText(double change){
    if(change > 0){
      return "增加了${change.toStringAsFixed(2)}Kg";
    }
    else if(change < 0){
      return "減少了${change.abs().toStringAsFixed(2)}Kg";
    }
    else{
      return "沒有變化";
    }
  }

  String getTargetText(double source, double target){
    if(source.toStringAsFixed(2) == target.toStringAsFixed(2)){
      return "恭喜您成功達成目標體重！";
    }
    else{
      String w = (source - target).abs().toStringAsFixed(2);
      return "距離目標體重尚差${w}Kg";
    }
  }

  int getCalories(){
    int c;
    if(Data.targetWeight < 0){
      c = (suggestWeight * 25).round();
    }else{
      c = (Data.targetWeight * 25).round();
    }
    return c;
  }
}

class sElement{
  double weight;
  int id;
  sElement(this.id ,this.weight);
}
