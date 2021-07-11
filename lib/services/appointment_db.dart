import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med_reminder/main.dart';
import 'package:med_reminder/models/appointment.dart';
import 'package:med_reminder/services/notifications.dart';
import 'package:intl/intl.dart';

class AppointmentDatabaseService {

  final String uid;

  AppointmentDatabaseService({ this.uid });

  final CollectionReference appointmentCollection = FirebaseFirestore.instance
      .collection('appointments');
  final format1 = DateFormat('yyyy/MM/dd – HH:mm');
  final format2 = DateFormat('dd/MM/yyyy - HH:mm');

  Future setAppointmentDB() async {
    return await appointmentCollection.doc(uid)
        .collection('user_appointments')
        .doc()
        .set({});
  }

  Future createAppointmentData(String doctorsname, String specialty,
      String address, String date, String note) async {
    return await appointmentCollection.doc(uid)
        .collection('user_appointments')
        .add({
      'appointmentid': '',
      'doctorsname': doctorsname,
      'specialty': specialty,
      'address': address,
      'date': date,
      'note': note
    })
        .then((docRef) async {
        await AppointmentNotificationService().createAppointmentNotif(docRef.id, uid, date);
        docRef.update({
          'appointmentid': docRef.id
        });

    });
  }

  Future updateAppointmentData(String appointmentid, String doctorsname,
      String specialty, String address, String date, String note) async {
    await AppointmentNotificationService().updateAppointmentNotif(appointmentid, uid, date);
    return await appointmentCollection.doc(uid)
        .collection('user_appointments')
        .doc(appointmentid)
        .set({
      'appointmentid': appointmentid,
      'doctorsname': doctorsname,
      'specialty': specialty,
      'address': address,
      'date': date,
      'note': note
    });
  }

  Future deleteAppointmentData(String appointmentid) async {
    await AppointmentNotificationService().deleteAppointmentNotif(appointmentid);
    return await appointmentCollection.doc(uid)
        .collection('user_appointments')
        .doc(appointmentid)
        .delete();
  }


  //appointment list from snapshot
  List<AppointmentData> _appointmentListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AppointmentData(
        appointmentid: doc.data()['appointmentid'] ?? '',
        doctorsname: doc.data()['doctorsname'] ?? '',
        specialty: doc.data()['specialty'] ?? '',
        address: doc.data()['address'] ?? '',
        date: format2.format(format1.parse(doc.data()['date'])) ?? '',
        note: doc.data()['note'] ?? '',
      );
    }).toList();
  }

  //get appointments stream
  Stream<List<AppointmentData>> get appointments {
    return appointmentCollection.doc(uid).collection('user_appointments')
        .orderBy('date', descending: false).snapshots()
        .map(_appointmentListFromSnapshot);
  }

  Future getDateAppointments(DateTime date) async {
    List<String> timelist = [];
    String datestr = format1.format(date);
    await appointmentCollection.doc(uid).collection('user_appointments')
        .where("date", isGreaterThan: datestr)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Map<String, dynamic> appointment = result.data();
        if (DateFormat("yyyy/MM/dd").format(
            date.add(const Duration(days: 1))) ==
            appointment['date'].substring(0, 10)) {
          timelist.add(appointment['date'].substring(13, 18));
        }
      });
    });
    return timelist;
  }
}