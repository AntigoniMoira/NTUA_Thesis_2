import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med_reminder/models/med.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:med_reminder/shared/constants.dart';
import 'package:med_reminder/services/user_db.dart';
import 'package:med_reminder/services/storage.dart';
import 'package:med_reminder/services/notifications.dart';
import 'package:http/http.dart' as http;

class MedDatabaseService {

  final String uid;
  MedDatabaseService({ this.uid });

  final CollectionReference medCollection = FirebaseFirestore.instance.collection('meds');
  final dbRef = FirebaseDatabase.instance.reference().child("meds");
  final format1 = DateFormat('yyyy/MM/dd');
  final format2 = DateFormat('dd/MM/yyyy');

  // Future setMedDB() async {
  //   return await medCollection.doc(uid).collection('user_meds').doc().set({});
  // }

  Future getMedImg(String name) async {
    String barcode;
    String ntua_img;
    await dbRef.orderByChild("name").equalTo(name).limitToFirst(1).once().then((
        DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        barcode = values["barcode"];
        ntua_img = values["ntua_img"];
      });
    });
    return MedInfo(
      name: name ?? '',
      barcode: barcode?? '',
      img: ntua_img ?? ''
    );
  }

  Future createMedData(NewMed newmed) async {
    String barcode;
    String ntua_img;
    String gal_img;
    await dbRef.orderByChild("name").equalTo(newmed.name).limitToFirst(1).once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key,values) {
        barcode = values["barcode"];
        ntua_img = values["ntua_img"];
        gal_img = values["gal_img"];
      });
    });
    return await medCollection.doc(uid).collection('user_meds').add({
      'medid': '',
      'name': newmed.name,
      'barcode': barcode,
      'ntua_img': ntua_img,
      'gal_img': gal_img,
      'symptom': newmed.symptom,
      'meal': newmed.meal,
      'units': newmed.units,
      'dosage': newmed.dosage,
      'periodicity': newmed.periodicity,
      'daysX': newmed.daysX,
      'daysXY': newmed.daysXY,
      'daysWeek': newmed.daysWeek,
      'dateStart': newmed.dateStart,
      'dateEnd': newmed.dateEnd,
      'timesperday': newmed.timesperday,
      'intaketime': newmed.intaketime
    }).then((docRef) async {
      await MedNotificationService().createMedNotif(docRef.id, uid, newmed.name, newmed.periodicity, newmed.daysX, newmed.daysXY, newmed.daysWeek, newmed.dateStart, newmed.dateEnd, newmed.timesperday, newmed.intaketime);
      docRef.update({
        'medid': docRef.id
      });
    });
  }

  Future updateMedData(String medid) async {
    return await medCollection.doc(uid).collection('user_meds').doc(medid).update({
      'dateEnd': DateFormat('dd/MM/yyyy').format(new DateTime.now())
    });
  }

  Future deleteMedData(String medid) async {
    await MedNotificationService().deleteMedNotif(medid);
    return await medCollection.doc(uid).collection('user_meds').doc(medid).delete();
  }


  //med list from snapshot
  List<MedData> _medListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      String image = doc.data()['ntua_img'] != '' ? doc.data()['ntua_img'] : doc.data()['gal_img'];
      return MedData(
          medid: doc.data()['medid'] ?? '',
          name: doc.data()['name'] ?? '',
          barcode: doc.data()['barcode'] ?? '',
          image: image ?? '',
          symptom: doc.data()['symptom'] ?? '',
          meal: doc.data()['meal'] ?? '',
          units: doc.data()['units'] ?? '',
          dosage: doc.data()['dosage'] ?? '',
          periodicity: doc.data()['periodicity'] ?? 1,
          daysX: doc.data()['daysX'] ?? 1,
          daysXY: doc.data()['daysXY'] ?? [21,7],
          daysWeek: doc.data()['daysWeek'] ?? [false, false, false, false, false, false, false],
          dateStart: format2.format(format1.parse(doc.data()['dateStart'])) ?? '',
          dateEnd: format2.format(format1.parse(doc.data()['dateEnd'])) ?? '',
          timesperday: doc.data()['timesperday'] ?? '',
          intaketime: doc.data()['intaketime'] ?? ['00:00', '00:00', '00:00', '00:00']
      );
    }).toList();
  }

  //get meds stream
  Stream<List<MedData>> get meds {
    return medCollection.doc(uid).collection('user_meds').snapshots()
        .map(_medListFromSnapshot);
  }

  Future<List> medNames(String currentName) async {
    List<String> nameList = [];
    try {
      await dbRef.orderByChild("name").startAt(currentName).limitToFirst(10).once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key,values) {
          nameList.add(values["name"]);
          });
      });
      return nameList;
    }
    catch (e){
      print('caught error: $e');
    }
  }

  Future  getDateMeds(DateTime date) async {
    List<MedIntake> intakelist = [];
    String datestr = format1.format(date);
    await medCollection.doc(uid).collection('user_meds')
        .where("dateEnd", isGreaterThanOrEqualTo: datestr)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Map<String, dynamic> med = result.data();
        if(format1.parse(datestr).isAfter(format1.parse(med['dateStart'])) || datestr == med['dateStart']){
          int daysfromstart = daysBetween(format1.parse(med['dateStart']), date);
          String image = med['ntua_img'] != '' ? med['ntua_img'] : med['gal_img'];
          switch(med['periodicity']) {
            case 1 :
              {
                for(var i=0; i<med['timesperday']; i++) {
                  final MedIntake newintake = new MedIntake(
                      name: med['name'],
                      image: image,
                      symptom: med['symptom'],
                      meal: med['meal'],
                      units: med['units'],
                      dosage: med['dosage'],
                      intaketime: med['intaketime'][i]
                  );
                  intakelist.add(newintake);
                }
              }
              break;
            case 2 :
              {
                for(var i=0; i<med['timesperday']; i++) {
                  final MedIntake newintake = new MedIntake(
                      name: med['name'],
                      image: image,
                      symptom: med['symptom'],
                      meal: med['meal'],
                      units: med['units'],
                      dosage: med['dosage'],
                      intaketime: med['intaketime'][i]
                  );
                  intakelist.add(newintake);
                }
              }
              break;
            case 3 :
              {
                if (daysfromstart % med['daysX'] == 0) {
                  for (var i = 0; i < med['timesperday']; i++) {
                    final MedIntake newintake = new MedIntake(
                        name: med['name'],
                        image: image,
                        symptom: med['symptom'],
                        meal: med['meal'],
                        units: med['units'],
                        dosage: med['dosage'],
                        intaketime: med['intaketime'][i]
                    );
                    intakelist.add(newintake);
                  }
                }
              }
              break;
            case 4 :
              {
                if(med['daysWeek'][date.weekday % 7]) {
                  for (var i = 0; i < med['timesperday']; i++) {
                    final MedIntake newintake = new MedIntake(
                        name: med['name'],
                        image: image,
                        symptom: med['symptom'],
                        meal: med['meal'],
                        units: med['units'],
                        dosage: med['dosage'],
                        intaketime: med['intaketime'][i]
                    );
                    intakelist.add(newintake);
                  }
                }
              }
              break;
            case 5 :
              {
                if (daysfromstart % (med['daysXY'][0]+med['daysXY'][1]) <= med['daysXY'][0]) {
                  for (var i = 0; i < med['timesperday']; i++) {
                    final MedIntake newintake = new MedIntake(
                        name: med['name'],
                        image: image,
                        symptom: med['symptom'],
                        meal: med['meal'],
                        units: med['units'],
                        dosage: med['dosage'],
                        intaketime: med['intaketime'][i]
                    );
                    intakelist.add(newintake);
                  }
                }
              }
              break;
              default: {

              }
              break;


          }
        }
      });
    });

    intakelist.sort((a, b) => a.intaketime.compareTo(b.intaketime));
    if(format1.format(date) == format1.format(DateTime.now())){
      List<dynamic> deletelist = await UserDatabaseService(uid: uid).getTodayMeds();
      if(deletelist != null){
        intakelist.removeWhere((item) => deletelist.contains(item.intaketime+item.name));
      }
    }
    return intakelist;

  }

}

Future getMedImg(String name) async {
  String barcode;
  String ntua_img = 'notfound';
  try {
    await FirebaseDatabase.instance.reference().child("meds").orderByChild(
        "name").equalTo(name).limitToFirst(1).once().then((
        DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        barcode = values["barcode"];
        ntua_img = values["ntua_img"];
      });
    });
  }
  catch (e) {
    print('caught error: $e');
  }
  return MedInfo(
      name: name ?? '',
      barcode: barcode?? '',
      img: ntua_img ?? ''
  );
}

Future<void> uploadAndUpdateDB (barcode, imgPath) async {
  String imgurl = await StorageService(imgPath: imgPath).uploadImg();

  File _imageFile =  File(imgPath);
  String fileName = basename(_imageFile.path);
  String medBarcode = fileName.split(".")[0];
  var url = 'https://www.galinos.gr/service/documents/display/drugs/package/$barcode';
  var galImg = '';
  var response = await http.get(url);
  if (response.statusCode == 200) {
    galImg = url;
  }
  try {
    await  FirebaseDatabase.instance.reference().child("meds/$barcode").update({
      'ntua_img': imgurl,
      'gal_img' : galImg,
      'pill_img': 'user'
    });
  }
  catch (e){
    print('caught error: $e');
  }

}
