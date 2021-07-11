import 'package:flutter/material.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/models/appointment.dart';
import 'package:med_reminder/services/appointment_db.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AppointmentForm extends StatefulWidget {

  final AppointmentData appointment;
  final String mode;
  AppointmentForm( this.appointment, this.mode );

  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {

  final _formKey = GlobalKey<FormState>();
  final format = DateFormat('dd/MM/yyyy – HH:mm');
  TextEditingController _dateController = TextEditingController()..text = DateFormat('dd/MM/yyyy – HH:mm').format(new DateTime.now());


  // form values
  String _currentDoctorsName;
  String _currentSpecialty;
  String _currentAddress;
  DateTime _currentDate;
  String _currentNote;
  DateTime dayPicked;
  TimeOfDay timePicked;

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

    AppointmentData appointment = widget.appointment;
    String mode = widget.mode;

    // var format = DateFormat('yyyy-MM-dd – HH:mm');
    DateTime dateNow = (mode == 'edit') ? DateFormat('dd/MM/yyyy  HH:mm').parse(appointment.date.replaceFirst('-', '')) : new DateTime.now();
    // _selectDate(context, dateNow);

    return Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                initialValue: _currentDoctorsName ?? appointment.doctorsname,
                decoration: const InputDecoration(
                  hintText: 'Γράψτε το όνομα του ιατρού σας.',
                  labelText: 'Όνομα Ιατρού',
                ),
                validator: (val) =>
                  val.isEmpty
                      ? 'Παρακαλώ εισάγετε ένα όνομα.'
                      : null,
                onChanged: (val) => setState(() => _currentDoctorsName = val),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                initialValue: _currentSpecialty ?? appointment.specialty,
                decoration: const InputDecoration(
                  hintText: 'Γράψτε την ειδικότητα',
                  labelText: 'Ειδικότητα Ιατρού',
                ),
                validator: (val) =>
                val.isEmpty
                    ? 'Παρακαλώ εισάγετε την ειδικότητα του ιατρού σας.'
                    : null,
                onChanged: (val) => setState(() => _currentSpecialty = val),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                initialValue: _currentAddress ?? appointment.address,
                decoration: const InputDecoration(
                  hintText: 'Γράψτε την διεύθυνση του ιατρίου.',
                  labelText: 'Διεύθυνση ιατρίου',
                ),
                onChanged: (val) => setState(() => _currentAddress= val),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Ημερομηνία',
                ),
                readOnly: true,
                controller: _dateController,
                onTap: () => _selectDate(context, dateNow),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                initialValue: _currentNote ?? appointment.note,
                decoration: const InputDecoration(
                  hintText: 'Γράψτε μια σημείωση σχετικά με το ραντεβού σας.',
                  labelText: 'Σημείωση',
                ),
                onChanged: (val) => setState(() => _currentNote= val),
              ),
              SizedBox(height: 10.0),
              RaisedButton(
                color: Color.fromRGBO(50, 60, 107, 1),
                child: Text(
                  'Αποθήκευση',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if(_formKey.currentState.validate()) {
                    if (mode == 'new') {
                      await AppointmentDatabaseService(uid: user.uid)
                          .createAppointmentData(
                            _currentDoctorsName,
                            _currentSpecialty,
                            _currentAddress,
                            (_currentDate == null) ? DateFormat('yyyy/MM/dd – HH:mm').format(dateNow) : DateFormat('yyyy/MM/dd – HH:mm').format(_currentDate),
                            _currentNote
                          );
                    }
                    else{
                      await AppointmentDatabaseService(uid: user.uid)
                          .updateAppointmentData(
                            appointment.appointmentid,
                            _currentDoctorsName ?? appointment.doctorsname,
                            _currentSpecialty ?? appointment.specialty,
                            _currentAddress ?? appointment.address,
                            (_currentDate == null) ? DateFormat('yyyy/MM/dd – HH:mm').format(dateNow) : DateFormat('yyyy/MM/dd – HH:mm').format(_currentDate),
                           _currentNote
                      );
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
