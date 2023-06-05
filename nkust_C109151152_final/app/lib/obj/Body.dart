class Body{
  late double height;
  late double weight;
  late double bmi;
  late String date;
  late int action;

  Body(double height, double weight, String date, int action){
    this.height = height;
    this.weight = weight;
    this.date = date;
    double h = height/100;
    this.bmi = weight / (h * h);
    this.action = action;
  }

  Body.withBmi(double height, double weight, double bmi, String date, int action){
    this.height = height;
    this.weight = weight;
    this.bmi = bmi;
    this.date = date;
    this.action = action;
  }

  Map<String, dynamic> toMap(){
    return {
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'date': date,
      'action': action,
    };
  }

}