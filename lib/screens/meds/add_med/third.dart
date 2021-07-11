import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:med_reminder/models/med.dart';
import 'package:med_reminder/services/med_db.dart';
import 'package:med_reminder/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/models/user.dart';
import 'package:intl/intl.dart';
import 'package:select_form_field/select_form_field.dart';

class Third extends StatefulWidget {
  final NewMed med;
  Third({Key key, @required this.med}) : super(key: key);

  @override
  _ThirdState createState() => _ThirdState();
}

class _ThirdState extends State<Third> {

  final _formKey = GlobalKey<FormState>();
  final format1 = DateFormat('dd/MM/yyyy');
  final format2 = DateFormat('yyyy/MM/dd');
  TextEditingController _dateStartController = TextEditingController()..text = DateFormat('dd/MM/yyyy').format(new DateTime.now().add(const Duration(days: 1)));
  TextEditingController _dateEndController = TextEditingController()..text = DateFormat('dd/MM/yyyy').format(new DateTime.now().add(const Duration(days: 1)));
  List<TextEditingController> _timeController = [TextEditingController()..text = '00:00', TextEditingController()..text = '00:00', TextEditingController()..text = '00:00', TextEditingController()..text = '00:00'];

  // DateTime _currentDateStart;
  // DateTime _currentDateEnd;
  int _currentTimesPerDay = 1;
  List<TimeOfDay> timeslots= [TimeOfDay(hour: 00, minute: 00), TimeOfDay(hour: 00, minute: 00), TimeOfDay(hour: 00, minute: 00), TimeOfDay(hour: 00, minute: 00)];


  Future<void> _selectDate(BuildContext context, bool start) async {

    await showDatePicker(
        context: context,
        locale: const Locale("el", "GR"),
        initialDate: start ? format1.parse(_dateStartController.text) : format1.parse(_dateEndController.text),
        firstDate: DateTime.now().add(const Duration(days: 1)),
        lastDate: DateTime(2030),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark(),
            child: child,
          );
        }
    ).then((date) {
      setState(() {
        if (start){
          _dateStartController.text = format1.format(date);
        } else {
          _dateEndController.text = format1.format(date);
        }
      });
    });
  }

  Future<void> _selectTime(BuildContext context, int intake, TimeOfDay selectedTime) async {

    await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        }
    ).then((time) {
      setState(() {
        timeslots[intake]= time;
        _timeController[intake].text = formatTimeOfDay(time);
      });
    });
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat("HH:mm");
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    NewMed med = widget.med;

    Widget _customDate(NewMed med) {
      if (med.periodicity == 2){
        return TextFormField(
          // initialValue: 'Hello',
          decoration: const InputDecoration(
            labelText: 'Ημερομηνία',
          ),
          readOnly: true,
          controller: _dateStartController,
          onTap: () => _selectDate(context, true),
        );
      } else {
        return Column(
          children: <Widget>[
            TextFormField(
              // initialValue: 'Hello',
              decoration: const InputDecoration(
                labelText: 'Ημερομηνία Έναρξης',
              ),
              readOnly: true,
              controller: _dateStartController,
              onTap: () => _selectDate(context, true),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              decoration: const InputDecoration(
              labelText: 'Ημερομηνία Ολοκλήρωσης',
              ),
              readOnly: true,
              controller: _dateEndController,
              onTap: () => _selectDate(context, false),
            ),
          ]
        );
      }
    }

    Widget _customIntakes() {
      List<Widget> list = new List<Widget>();
      for(var i = 0; i < _currentTimesPerDay; i++){
        list.add(new Container(
          width: 45.0,
          child:TextFormField(
          readOnly: true,
          controller: _timeController[i],
          onTap: () => _selectTime(context, i, timeslots[i]),
          )),);
      }
      return new Column(children: list);
    }

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromRGBO(225, 230, 233, 1),
        // drawer: NavBar(),
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          backgroundColor: Color.fromRGBO(50, 60, 107, 1),
          elevation: 0.0,
          title: Text('Καταχώρηση Φαρμάκου - Βήμα 3'),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _customDate(med),
                    SizedBox(height: 15.0),
                    SelectFormField(
                      // type: dropdown, // or can be dialog
                      initialValue: '1',
                      labelText: 'Δόσεις ανά ημέρα',
                      items: timesperday,
                      onChanged: (val) {
                        setState(() {
                          _currentTimesPerDay = int.parse(val);
                        });
                      },
                      // onSaved: (val) => print(val),
                    ),
                    SizedBox(height: 15.0),
                    _customIntakes(),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      color: Color.fromRGBO(50, 60, 107, 1),
                      child: Text(
                        'Αποθήκευση',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if(_formKey.currentState.validate()) {
                          med.dateStart = format2.format(format1.parse(_dateStartController.text));
                          med.dateEnd = (med.periodicity == 2) ? format2.format(format1.parse(_dateStartController.text)) : format2.format(format1.parse(_dateEndController.text));
                          med.timesperday = _currentTimesPerDay;
                          med.intaketime = [formatTimeOfDay(timeslots[0]), formatTimeOfDay(timeslots[1]), formatTimeOfDay(timeslots[2]), formatTimeOfDay(timeslots[3])];
                          await MedDatabaseService(uid: user.uid)
                                .createMedData(med);
                          // Navigator.of(context).popUntil((route) => route.isFirst);
                          Navigator.popUntil(context, ModalRoute.withName('/meds'));
                        }
                      },
                    ),
                  ],
                )
            )
        )
    );
  }
}