import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med_reminder/models/measurement.dart';
import 'package:intl/intl.dart';

class MeasurementDatabaseService {

  final String uid;
  MeasurementDatabaseService({ this.uid });

  final CollectionReference measurementCollection = FirebaseFirestore.instance.collection('measurements');
  final format1 = DateFormat('yyyy/MM/dd – HH:mm');
  final format2 = DateFormat('dd/MM/yyyy - HH:mm');

  // Future setMeasurementDB() async {
  //   return await measurementCollection.doc(uid).collection('user_measurements').doc().set({});
  // }

  Future createPressureData(String value, String date) async {
    return await measurementCollection.doc(uid).collection('user_pressure').add({
      'pressureid': '',
      'value': value,
      'date': date
    }).then((docRef) => {
      docRef.update({
        'pressureid': docRef.id
      })
    });
  }

  Future createGlucoseData(String value, String date) async {
    return await measurementCollection.doc(uid).collection('user_glucose').add({
      'glucoseid': '',
      'value': value,
      'date': date
    }).then((docRef) => {
      docRef.update({
        'glucoseid': docRef.id
      })
    });
  }

  Future createTemperatureData(String value, String date) async {
    return await measurementCollection.doc(uid).collection('user_temperature').add({
      'tempid': '',
      'value': value,
      'date': date
    }).then((docRef) => {
      docRef.update({
        'tempid': docRef.id
      })
    });
  }

  Future deletePressureData(String pressureid) async {
    return await measurementCollection.doc(uid).collection('user_pressure').doc(pressureid).delete();
  }

  Future deleteGlucoseData(String glucoseid) async {
    return await measurementCollection.doc(uid).collection('user_glucose').doc(glucoseid).delete();
  }

  Future deleteTemperatureData(String tempid) async {
    return await measurementCollection.doc(uid).collection('user_temperature').doc(tempid).delete();
  }

  //pressure list from snapshot
  List<PressureData> _pressureListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PressureData(
          pressureid: doc.data()['pressureid'] ?? '',
          value: doc.data()['value'] ?? '',
          date: format2.format(format1.parse(doc.data()['date'])) ?? ''
      );
    }).toList();
  }

  //get pressures stream
  Stream<List<PressureData>> get pressures {
    return measurementCollection.doc(uid).collection('user_pressure').orderBy('date', descending: true).snapshots()
        .map(_pressureListFromSnapshot);
  }

  //glucose list from snapshot
  List<GlucoseData> _glucoseListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return GlucoseData(
          glucoseid: doc.data()['glucoseid'] ?? '',
          value: doc.data()['value'] ?? '',
          date: format2.format(format1.parse(doc.data()['date'])) ?? ''
      );
    }).toList();
  }

  //get glucoses stream
  Stream<List<GlucoseData>> get glucoses {
    return measurementCollection.doc(uid).collection('user_glucose').orderBy('date', descending: true).snapshots()
        .map(_glucoseListFromSnapshot);
  }

  //temperature list from snapshot
  List<TemperatureData> _temperatureListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TemperatureData(
        tempid: doc.data()['tempid'] ?? '',
        value: doc.data()['value'] ?? '',
        date: format2.format(format1.parse(doc.data()['date'])) ?? ''
      );
    }).toList();
  }

  //get temperatures stream
  Stream<List<TemperatureData>> get temperatures {
    return measurementCollection.doc(uid).collection('user_temperature').orderBy('date', descending: true).snapshots()
        .map(_temperatureListFromSnapshot);
  }

}