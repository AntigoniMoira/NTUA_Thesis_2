import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med_reminder/models/assistant.dart';

class AssistantDatabaseService {

  final String uid;
  AssistantDatabaseService({ this.uid });

  final CollectionReference assistantCollection = FirebaseFirestore.instance.collection('assistants');

  // Future setAssistantDB() async {
  //   return await assistantCollection.doc(uid).collection('user_assistants').doc().set({});
  // }

  Future createAssistantData(String name, String relationship, String mobile, String phone, String email) async {
    return await assistantCollection.doc(uid).collection('user_assistants').add({
      'assistantid': '',
      'name': name,
      'relationship': relationship,
      'mobile': mobile,
      'phone': phone,
      'email': email
    }).then((docRef) => {
      docRef.update({
        'assistantid': docRef.id
      })
    });
  }

  Future updateAssistantData(String assistantid, String name, String relationship, String mobile,
      String phone, String email) async {
    return await assistantCollection.doc(uid).collection('user_assistants').doc(assistantid).set({
      'assistantid': assistantid,
      'name': name,
      'relationship': relationship,
      'mobile': mobile,
      'phone': phone,
      'email': email
    });
  }

  Future deleteAssistantData(String assistantid) async {
    return await assistantCollection.doc(uid).collection('user_assistants').doc(assistantid).delete();
  }


  //assistant list from snapshot
  List<AssistantData> _assistantListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AssistantData(
          assistantid: doc.data()['assistantid'] ?? '',
          name: doc.data()['name'] ?? '',
          relationship: doc.data()['relationship'] ?? '',
          mobile: doc.data()['mobile'] ?? '',
          phone: doc.data()['phone'] ?? '',
          email: doc.data()['email'] ?? ''
      );
    }).toList();
  }

  //get assistants stream
  Stream<List<AssistantData>> get assistants {
    return assistantCollection.doc(uid).collection('user_assistants').snapshots()
        .map(_assistantListFromSnapshot);
  }

}