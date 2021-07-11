class MedData {

  String medid;
  String name;
  String barcode;
  String image;
  String symptom;
  String meal;
  String units;
  String dosage;
  int periodicity;
  int daysX;
  List<dynamic> daysXY;
  List<dynamic> daysWeek;
  String dateStart;
  String dateEnd;
  int timesperday;
  List<dynamic> intaketime;


  MedData({this.medid, this.name, this.barcode, this.image, this.symptom, this.meal, this.units, this.dosage, this.periodicity, this.daysX, this.daysXY, this.daysWeek, this.dateStart, this.dateEnd, this.timesperday, this.intaketime});

}

class NewMed {

  String name;
  String symptom;
  String meal;
  String units;
  String dosage;
  int periodicity;
  int daysX;
  List<int> daysXY;
  List<bool> daysWeek;
  String dateStart;
  String dateEnd;
  int timesperday;
  List<String> intaketime;


  NewMed({this.name, this.symptom, this.meal, this.units, this.dosage, this.periodicity, this.daysX, this.daysXY, this.daysWeek, this.dateStart, this.dateEnd, this.timesperday, this.intaketime});

}

class MedIntake {

  int id;
  String name;
  String image;
  String symptom;
  String meal;
  String units;
  String dosage;
  String intaketime;


  MedIntake({this.id, this.name, this. image, this.symptom, this.meal, this.units, this.dosage, this.intaketime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'symptom': symptom,
      'meal': meal,
      'units': units,
      'dosage': dosage,
      'intaketime': intaketime
    };
  }

}

class MedInfo {

  String name;
  String barcode;
  String img;

  MedInfo({this.name, this. img, this.barcode});
}