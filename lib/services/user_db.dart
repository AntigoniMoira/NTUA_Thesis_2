import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med_reminder/services/appointment_db.dart';
import 'package:med_reminder/services/assistant_db.dart';
import 'package:med_reminder/services/measurement_db.dart';
import 'package:med_reminder/services/med_db.dart';
import 'package:med_reminder/models/brew.dart';
import 'package:med_reminder/models/doctor.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/services/note_db.dart';
import 'package:med_reminder/services/prescription_db.dart';
import 'package:med_reminder/services/doctor_db.dart';

class UserDatabaseService {

  final String uid;
  UserDatabaseService({ this.uid });


  //collection reference
  // final CollectionReference brewCollection = FirebaseFirestore.instance.collection('brews');
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future initializeUserData(String name, String email, String birthdate, String gender, int height, double weight, int today_counter, List<dynamic> today_meds, List<dynamic> tokens) async {
    try {
      return await userCollection.doc(uid).set({
        'name': name,
        'email': email,
        'userid': uid,
        'birthdate': birthdate,
        'gender': gender,
        'height': height,
        'weight': weight,
        'today_counter': today_counter,
        'today_meds': today_meds,
        'tokens': tokens
      });
    }catch(e) {
      print(e.toString());
      return null;
    }

  }

  Future updateUserData(String name, String email, String birthdate, String gender, int height, double weight) async {
    return await userCollection.doc(uid).set({
        'name': name,
        'email': email,
        'userid': uid,
        'birthdate': birthdate,
        'gender': gender,
        'height': height,
        'weight': weight,
      });
  }

  // userProfile from snapshot
  UserProfile _userProfileFromSnapshot(DocumentSnapshot snapshot) {
      return  UserProfile(
        uid: uid,
        name: snapshot.data()['name'] ,
        email: snapshot.data()['email'],
        birthdate: snapshot.data()['birthdate'],
        gender: snapshot.data()['gender'],
        height: snapshot.data()['height'],
        weight: snapshot.data()['weight'],
        today_counter: snapshot.data()['today_counter'],
        today_meds: snapshot.data()['today_meds'],
        tokens: snapshot.data()['tokens']
      );
  }

  // get user doc stream
  Stream<UserProfile> get userProfile {
    return userCollection.doc(uid).snapshots()
    .map(_userProfileFromSnapshot);
  }

  Future updateTodayCounter(int medcounter) async {
    return await userCollection.doc(uid).update({
      'today_counter': medcounter
    });
  }

  Future updateTodayMeds(List<dynamic> medlist) async {
    return await userCollection.doc(uid).update({
      'today_meds': medlist
    });
  }

  Future updateTokens(List<dynamic> tokens) async {
    return await userCollection.doc(uid).update({
      'tokens': tokens
    });
  }

  Future getTodayCounter() async {
    DocumentSnapshot variable = await userCollection.doc(uid).get();
    return variable.data()["today_counter"];
  }

  Future getTodayMeds() async {
    DocumentSnapshot variable = await userCollection.doc(uid).get();
    return variable.data()["today_meds"];
  }

  Future getTokens() async {
    DocumentSnapshot variable = await userCollection.doc(uid).get();
    return variable.data()["tokens"];
  }

}