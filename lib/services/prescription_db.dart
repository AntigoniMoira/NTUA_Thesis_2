import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med_reminder/models/prescription.dart';
import 'package:med_reminder/services/notifications.dart';
import 'package:intl/intl.dart';

class PrescriptionDatabaseService {

  final String uid;
  PrescriptionDatabaseService({ this.uid });

  final CollectionReference prescriptionCollection = FirebaseFirestore.instance.collection('prescriptions');
  final format1 = DateFormat('yyyy/MM/dd');
  final format2 = DateFormat('dd/MM/yyyy');

  // Future setPrescriptionDB() async {
  //   return await prescriptionCollection.doc(uid).collection('user_prescriptions').doc().set({});
  // }

  Future createPrescriptionData(String barcode, String datestart, String dateend, String category) async {
    return await prescriptionCollection.doc(uid).collection('user_prescriptions').add({
      'prescriptionid': '',
      'barcode': barcode,
      'datestart': datestart,
      'dateend': dateend,
      'category': category
    }).then((docRef) async {
      await PrescriptionNotificationService().createPrescriptionNotif(docRef.id, uid, datestart, dateend);
      docRef.update({
        'prescriptionid': docRef.id
      });
    });
  }

  // Future updatePrescriptionData(String prescriptionid, String barcode, String datestart, String dateend, String category) async {
  //   return await prescriptionCollection.doc(uid).collection('user_prescriptions').doc(prescriptionid).set({
  //     'prescriptionid':prescriptionid,
  //     'barcode': barcode,
  //     'datestart': datestart,
  //     'dateend': dateend,
  //     'category': category
  //   });
  // }

  Future deletePrescriptionData(String prescriptionid) async {
    await PrescriptionNotificationService().deletePrescriptionNotif(prescriptionid);
    return await prescriptionCollection.doc(uid).collection('user_prescriptions').doc(prescriptionid).delete();
  }


  //prescription list from snapshot
  List<PrescriptionData> _prescriptionListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PrescriptionData(
          prescriptionid: doc.data()['prescriptionid'] ?? '',
          barcode: doc.data()['barcode'] ?? '',
          datestart: format2.format(format1.parse(doc.data()['datestart'])) ?? '',
          dateend: format2.format(format1.parse(doc.data()['dateend'])) ?? '',
          category: doc.data()['category'] ?? ''
      );
    }).toList();
  }

  //get prescriptions stream
  Stream<List<PrescriptionData>> get prescriptions {
    return prescriptionCollection.doc(uid).collection('user_prescriptions').orderBy('datestart', descending: false).snapshots()
        .map(_prescriptionListFromSnapshot);
  }

  Future getDatePrescriptions(DateTime date) async {
    List<bool> boollist = [false, false];
    String datestr = format1.format(date);
    await prescriptionCollection.doc(uid).collection('user_prescriptions')
        .where("dateend", isGreaterThanOrEqualTo: datestr)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Map<String, dynamic> prescription = result.data();
        if (datestr == prescription['datestart']) {
          boollist[0] = true;
        }
        if (datestr == prescription['dateend']) {
          boollist[1] = true;
        }
      });
    });
    return boollist;
  }

}