import 'package:flutter/material.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/models/note.dart';
import 'package:med_reminder/services/note_db.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NoteForm extends StatefulWidget {

  final NoteData note;
  final String mode;
  NoteForm( this.note, this.mode );

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {

  final _formKey = GlobalKey<FormState>();
  final format = DateFormat('dd/MM/yyyy – HH:mm');
  TextEditingController _dateController = TextEditingController()..text = DateFormat('dd/MM/yyyy – HH:mm').format(new DateTime.now());


  // form values
  String _currentText;
  DateTime _currentDate;
  DateTime dayPicked;
  TimeOfDay timePicked;
  String test;

  Future<void> _selectDate(BuildContext context, DateTime dateNow) async {

      await showDatePicker(
          context: context,
          locale: const Locale("el", "GR"),
          initialDate: _currentDate ?? dateNow,
          firstDate: DateTime(2021),
          lastDate: DateTime(2030),
          builder: (BuildContext context, Widget child) {
            return Theme(
              data: ThemeData.dark(),
              child: child,
            );
          }
      ).then((date) {
        setState(() {
          dayPicked = date;
        });
      });

      await showTimePicker(
          context: context,
          initialTime: (_currentDate == null)
              ? TimeOfDay.fromDateTime(dateNow)
              : TimeOfDay.fromDateTime(_currentDate),
          builder: (BuildContext context, Widget child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(alwaysUse24HourFormat: true),
              child: child,
            );
          }
      ).then((time) {
        setState(() {
          // _currentDate =  new DateTime(dayPicked.year, dayPicked.month, dayPicked.day, date.hour, date.minute);
          // _dateController.text = DateFormat('yyyy-MM-dd – HH:mm').format(_currentDate);
          timePicked = time;
        });
      });


    setState(() {
      _currentDate = new DateTime(dayPicked.year, dayPicked.month, dayPicked.day, timePicked.hour, timePicked.minute);
      _dateController.text = format.format(_currentDate);
    });
    // print(_currentDate);
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    NoteData note = widget.note;
    String mode = widget.mode;

    // var format = DateFormat('yyyy-MM-dd – HH:mm');

    DateTime dateNow = (mode == 'edit') ? DateFormat('dd/MM/yyyy  HH:mm').parse(note.date.replaceFirst('-', '')) : new DateTime.now();
    // _selectDate(context, dateNow);

    return Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                initialValue: _currentText ?? note.text,
                decoration: const InputDecoration(
                  hintText: 'Γράψτε την σημείωσή σας',
                  labelText: 'Κείμενο',
                ),
                validator: (val) =>
                  val.isEmpty
                      ? 'Παρακαλώ εισάγετε μια σημείωση.'
                      : null,
                onChanged: (val) => setState(() => _currentText = val),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                // initialValue: 'Hello',
                decoration: const InputDecoration(
                  labelText: 'Ημερομηνία',
                ),
                readOnly: true,
                controller: _dateController,
                onTap: () => _selectDate(context, dateNow),
              ),
              // GestureDetector(
              //   onTap: () => _selectDate(context, dateNow),
              //   child: AbsorbPointer(
              //     child: TextFormField(
              //       controller: _dateController,
              //       decoration: InputDecoration(
              //         labelText: 'Ημερομηνία',
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: 10.0),
              RaisedButton(
                color: Color.fromRGBO(50, 60, 107, 1),
                child: Text(
                  'Αποθήκευση',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  print(_currentDate);
                  if(_formKey.currentState.validate()) {
                    if (mode == 'new') {
                      await NoteDatabaseService(uid: user.uid)
                          .createNoteData(
                          _currentText, (_currentDate == null) ? DateFormat('yyyy/MM/dd – HH:mm').format(dateNow) : DateFormat('yyyy/MM/dd – HH:mm').format(_currentDate) );
                    }
                    else{
                      await NoteDatabaseService(uid: user.uid)
                          .updateNoteData(note.noteid,
                          _currentText ?? note.text, (_currentDate == null) ? DateFormat('yyyy/MM/dd – HH:mm').format(dateNow) : DateFormat('yyyy/MM/dd – HH:mm').format(_currentDate));
                    }
                    Navigator.pop(context);
                  }
                },
              ),
            ]
        )
    );

  }
}
