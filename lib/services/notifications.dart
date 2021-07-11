import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AppointmentNotificationService {

  final CollectionReference appointmentNotifCollection = FirebaseFirestore.instance.collection('appointments_notif');
  final format1 = DateFormat('yyyy/MM/dd');

  Future createAppointmentNotif(String docid, String uid, String date) async {

    DateTime yesterday = format1.parse(date.substring(0, 10)).add(const Duration(hours: -12));
    Timestamp notifDate = Timestamp.fromDate(yesterday);
    String time = date.substring(13, 18);
    if (DateTime.now().isBefore(yesterday)) {
      return await appointmentNotifCollection.doc(docid).set({
        'notifid': docid,
        'uid': uid,
        'whenToNotify': notifDate,
        'notificationSent': false,
        'body': 'Αύριο στις $time έχετε ραντεβού με τον γιατρό σας!'
      });
    }

  }

  Future updateAppointmentNotif(String docid, String uid, String date) async {

    DateTime yesterday = format1.parse(date.substring(0, 10)).add(const Duration(hours: -12));
    Timestamp notifDate = Timestamp.fromDate(yesterday);
    String time = date.substring(13, 18);

    return await appointmentNotifCollection.doc(docid).update({
      'notifid': docid,
      'uid': uid,
      'whenToNotify': notifDate,
      'notificationSent': false,
      'body': 'Αύριο στις $time έχετε ραντεβού με τον γιατρό σας!'
    });

  }


  Future deleteAppointmentNotif(String docid) async {
    return await appointmentNotifCollection.doc(docid).delete();
  }
}

class PrescriptionNotificationService {

  final CollectionReference prescriptionNotifCollection = FirebaseFirestore.instance.collection('prescriptions_notif');
  final format1 = DateFormat('yyyy/MM/dd');

  Future createPrescriptionNotif(String docid, String uid, String datestart, String dateend) async {

    String today = format1.format(DateTime.now());
    if(today.compareTo(datestart) == -1 || today.compareTo(datestart) == 0) {
      DateTime dateTimeStart = format1.parse(datestart).add(const Duration(hours: 10));
      Timestamp notifDate = Timestamp.fromDate(dateTimeStart);

      return await prescriptionNotifCollection.doc(docid).set({
        'notifid': docid,
        'uid': uid,
        'whenToNotify': notifDate,
        'notificationSent': false,
        'mode': 'start',
        'body': 'Σήμερα είναι η πρώτη μέρα εκτέλεσης της συνταγής σας'
      });
    }
    if (today.compareTo(dateend) == 1 || today.compareTo(dateend) == 0) {
      DateTime dateTimeEnd = format1.parse(dateend).add(const Duration(hours: 10));
      Timestamp notifDate = Timestamp.fromDate(dateTimeEnd);

      return await prescriptionNotifCollection.doc(docid).set({
        'notifid': docid,
        'uid': uid,
        'whenToNotify': notifDate,
        'notificationSent': false,
        'mode': 'end',
        'body': 'Σήμερα είναι η τελευταία μέρα εκτέλεσης της συνταγής σας'
      });
    }

  }


  Future deletePrescriptionNotif(String docid) async {
    return await prescriptionNotifCollection.doc(docid).delete();
  }
}

class MedNotificationService {

  final CollectionReference medNotifCollection = FirebaseFirestore.instance.collection('meds_notif');
  final format1 = DateFormat('yyyy/MM/dd - HH:mm');

  Future createMedNotif(String docid, String uid, String name, int periodicity, int daysX, List<int> daysXY, List<bool> daysWeek, String dateStart, String dateEnd, int timesperday, List<String> intaketime) async {

    DateTime pDate = format1.parse(dateStart + ' - ' + intaketime[0]);
    Timestamp notifDate = Timestamp.fromDate(pDate);

    if(periodicity == 3) {
      for (var i = 0; i < daysX; i++) {
        pDate = pDate.add(const Duration(days: 1));
      }
      notifDate = Timestamp.fromDate(pDate);
    }
    if(periodicity == 4) {
      while (!daysWeek[pDate.weekday % 7]) {
        pDate = pDate.add(const Duration(days: 1));
      }
      notifDate = Timestamp.fromDate(pDate);
    }


    return await medNotifCollection.doc(docid).set({
      'notifid': docid,
      'uid': uid,
      'whenToNotify': notifDate,
      'notificationSent': false,
      'currentdate': dateStart,
      'intake': 0,
      'body': 'Ώρα για το ${name.split(" ")[0]}'
    });


  }


  Future deleteMedNotif(String docid) async {
    return await medNotifCollection.doc(docid).delete();
  }
}