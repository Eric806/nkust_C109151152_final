import 'package:flutter/material.dart';

class Plan{
  late String name;
  late time start;
  late time end;
  late int duration;
  Plan(this.name, int week, int hour, int min, int duration){
    this.start = time(week, hour, min);
    this.duration = duration;
    int emin=min+duration;
    int ehour=emin~/60+hour;
    int eweek=ehour~/24+week;
    this.end = time(eweek%7, ehour%24, emin%60);
    if(duration == 0){
      throw timeError("start and end at the same time");
    }else if(duration < 0){
      throw timeError("duration is less than 0");
    }
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'week': start.week,
      'hour': start.hour,
      'min': start.min,
      'duration': duration,
    };
  }
}

class time{
  late int week;
  late int hour;
  late int min;

  time(this.week, this.hour, this.min){
    if(week > 6 || week < 0 || hour > 23 || hour < 0 || min > 60 || min < 0){
      print("${week} ${hour} ${min}");
      throw timeError("time value Error");
    }
  }

  String getWeek(){
    List<String> s = ["一", "二", "三", "四", "五", "六", "日"];
    return s[week];
  }

  String getHour(){
    return hour.toString().padLeft(2, '0');
  }

  String getMin(){
    return min.toString().padLeft(2, '0');
  }

}

class timeError extends Error{
  final String message;

  timeError(this.message);

  @override
  String toString() {
    return 'MyError: $message';
  }
}