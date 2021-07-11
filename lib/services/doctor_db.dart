import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med_reminder/models/doctor.dart';

class DoctorDatabaseService {

  final String uid;

  DoctorDatabaseService({ this.uid });

  final CollectionReference doctorCollection = FirebaseFirestore.instance.collection('doctors');

  // Future setDoctorDB() async {
  //   return await doctorCollection.doc(uid).collection('user_doctors').doc().set({});
  // }

  Future createDoctorData(String name, String specialty, String mobile, String phone, String email, String address) async {
    return await doctorCollection.doc(uid).collection('user_doctors').add({
      'doctorid': '',
      'name': name,
      'specialty': specialty,
      'mobile': mobile,
      'phone': phone,
      'email': email,
      'address': address
    }).then((docRef) => {
      docRef.update({
      'doctorid': docRef.id
      })
    });
  }

  Future updateDoctorData(String doctorid, String name, String specialty, String mobile,
      String phone, String email, String address) async {
    return await doctorCollection.doc(uid).collection('user_doctors').doc(doctorid).set({
      'doctorid': doctorid,
      'name': name,
      'specialty': specialty,
      'mobile': mobile,
      'phone': phone,
      'email': email,
      'address': address
    });
  }

  Future deleteDoctorData(String doctorid) async {
    return await doctorCollection.doc(uid).collection('user_doctors').doc(doctorid).delete();
  }


  //doctor list from snapshot
  List<DoctorData> _doctorListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return DoctorData(
          doctorid: doc.data()['doctorid'] ?? '',
          name: doc.data()['name'] ?? '',
          specialty: doc.data()['specialty'] ?? '',
          mobile: doc.data()['mobile'] ?? '',
          phone: doc.data()['phone'] ?? '',
          email: doc.data()['email'] ?? '',
          address: doc.data()['address'] ?? ''
      );
    }).toList();
  }

  // // userData from snapshot
  // DoctorData _doctorDataFromSnapshot(DocumentSnapshot snapshot) {
  //   return DoctorData(
  //       doctorid: snapshot.data()['doctorid'],
  //       name: snapshot.data()['name'],
  //       specialty: snapshot.data()['specialty'],
  //       mobile: snapshot.data()['mobile'],
  //       phone: snapshot.data()['phone'],
  //       email: snapshot.data()['email'],
  //       address: snapshot.data()['address']
  //   );
  // }

  //get doctors stream
  Stream<List<DoctorData>> get doctors {
    return doctorCollection.doc(uid).collection('user_doctors').snapshots()
        .map(_doctorListFromSnapshot);
  }

  // // get user doc stream
  // Stream<DoctorData> get doctorData {
  //   return doctorCollection.doc(uid).collection('user_doctors').doc(did).snapshots()
  //       .map(_doctorDataFromSnapshot);
  // }

}