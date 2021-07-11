import 'package:flutter/material.dart';
import 'package:med_reminder/screens/notes/note_list.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/models/note.dart';
import 'package:med_reminder/services/note_db.dart';

 class Notes extends StatelessWidget {
   @override
   Widget build(BuildContext context) {

     final user = Provider.of<AppUser>(context);

     return StreamProvider<List<NoteData>>.value(
       value: NoteDatabaseService(uid: user.uid).notes,
       child: Scaffold(
           backgroundColor: Color.fromRGBO(225, 230, 233, 1),
           appBar: AppBar(
             // automaticallyImplyLeading: false,
             backgroundColor: Color.fromRGBO(50, 60, 107, 1),
             elevation: 0.0,
             title: Text('Σημειώσεις'),
           ),
           floatingActionButton: FloatingActionButton(
             child: Icon(Icons.add),
             backgroundColor: Color.fromRGBO(50, 60, 107, 1),
             foregroundColor: Colors.white,
             onPressed: () async {
               Navigator.pushNamed(context, '/newnote');
             },
           ),
           body: Container(
               decoration: BoxDecoration(
                 image: DecorationImage(
                   image: AssetImage('assets/images/note-background.jpg'),
                   fit: BoxFit.cover,
                 ),
               ),
               child: NoteList()
           ),
       )
     );

   }
 }
