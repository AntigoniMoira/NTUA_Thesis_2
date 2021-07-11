import 'package:flutter/material.dart';
import 'package:med_reminder/models/note.dart';
import 'package:med_reminder/shared/constants.dart';

class NoteDetails extends StatelessWidget {

  final NoteData note;
  NoteDetails( this.note );

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              'ΣΗΜΕΙΩΣΗ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              note.text,
              style: dataStyle
          ),
          SizedBox(height: 20.0),
          Text(
              'ΗΜΕΡΟΜΗΝΙΑ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              note.date,
              style: dataStyle
          ),
          SizedBox(height: 20.0),
        ]
    );
  }
}
