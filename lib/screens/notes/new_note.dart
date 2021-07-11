import 'package:flutter/material.dart';
import 'package:med_reminder/models/note.dart';
import 'package:med_reminder/models/user.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/screens/notes/notes_form.dart';

class NewNote extends StatefulWidget {

  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    final NoteData emptyNote = NoteData(
      noteid: '',
      text: '',
      date: ''
    );

    return  Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromRGBO(225, 230, 233, 1),
        // drawer: NavBar(),
        appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(50, 60, 107, 1),
        elevation: 0.0,
        title: Text('Καταχώρηση Σημείωσης'),
        ),
        body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
        child: NoteForm(emptyNote, 'new'),
      )
    );
  }
}