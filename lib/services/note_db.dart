import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med_reminder/models/note.dart';
import 'package:intl/intl.dart';

class NoteDatabaseService {

  final String uid;
  NoteDatabaseService({ this.uid });

  final CollectionReference noteCollection = FirebaseFirestore.instance.collection('notes');
  final format1 = DateFormat('yyyy/MM/dd – HH:mm');
  final format2 = DateFormat('dd/MM/yyyy - HH:mm');

  // Future setNoteDB() async {
  //   return await noteCollection.doc(uid).collection('user_notes').doc().set({});
  // }

  Future createNoteData(String text, String date) async {
    return await noteCollection.doc(uid).collection('user_notes').add({
      'noteid': '',
      'text': text,
      'date': date
    }).then((docRef) => {
      docRef.update({
        'noteid': docRef.id
      })
    });
  }

  Future updateNoteData(String noteid, String text, String date) async {
    return await noteCollection.doc(uid).collection('user_notes').doc(noteid).set({
      'noteid': noteid,
      'text': text,
      'date': date
    });
  }

  Future deleteNoteData(String noteid) async {
    return await noteCollection.doc(uid).collection('user_notes').doc(noteid).delete();
  }


  //note list from snapshot
  List<NoteData> _noteListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return NoteData(
          noteid: doc.data()['noteid'] ?? '',
          text: doc.data()['text'] ?? '',
          date: format2.format(format1.parse(doc.data()['date'])) ?? ''
      );
    }).toList();
  }

  //get notes stream
  Stream<List<NoteData>> get notes {
    return noteCollection.doc(uid).collection('user_notes').orderBy('date', descending: true).snapshots()
        .map(_noteListFromSnapshot);
  }



}