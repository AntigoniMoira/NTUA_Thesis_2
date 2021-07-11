import 'package:flutter/material.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/services/measurement_db.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:med_reminder/shared/constants.dart';

class MeasurementForm extends StatefulWidget {

  @override
  _MeasurementFormState createState() => _MeasurementFormState();
}

class _MeasurementFormState extends State<MeasurementForm> {

  final _formKey = GlobalKey<FormState>();
  final format = DateFormat('dd/MM/yyyy – HH:mm');
  TextEditingController _dateController = TextEditingController()..text = DateFormat('dd/MM/yyyy – HH:mm').format(new DateTime.now());

  // form values
  String _currentType = '1';
  String _currentValue;
  String _currentPressureHigh;
  String _currentPressureLow;
  String _currentGlucose;
  String _currentTemperature;
  DateTime _currentDate;
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

    // var format = DateFormat('yyyy-MM-dd – HH:mm');
    DateTime dateNow = new DateTime.now();
    // _selectDate(context, dateNow);

    Widget _customInput() {
      switch (_currentType) {
        case '1':
          {
            return Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Text("Υψηλή:"),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: _currentPressureHigh,
                            keyboardType: TextInputType.number,
                            onChanged: (val) =>
                                setState(() {
                                  _currentPressureHigh = val;
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(" mmHg"),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Text(" Χαμηλή:"),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: _currentPressureLow,
                            keyboardType: TextInputType.number,
                            onChanged: (val) =>
                                setState(() {
                                  _currentPressureLow = val;
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(" mmHg"),
                  ),
                ]
            );
          }
          break;

        case '2':
          {
            return Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    initialValue: _currentGlucose,
                    keyboardType: TextInputType.number,
                    onChanged: (val) =>
                        setState(() {
                          _currentGlucose = val;
                        }),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text("mg/dl"),
                ),
                Expanded(
                  flex: 1,
                  child: Text(" "),
                ),
              ],
            );
          }
          break;

        case '3':
          {
            return Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    initialValue: _currentTemperature,
                    keyboardType: TextInputType.number,
                    onChanged: (val) =>
                        setState(() {
                          _currentTemperature = val;
                        }),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text("C"),
                ),
                Expanded(
                  flex: 1,
                  child: Text(" "),
                ),
              ],
            );
          }
          break;
        default:
          {
            return Text('');
          }
          break;
      }
    }

    return Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              SelectFormField(
                initialValue: '1',
                items: measurement_types,
                onChanged: (val) {
                  setState(() {
                    _currentType = val;
                  });
                },
                // onSaved: (val) => print(val),
              ),
              SizedBox(height: 20.0),
              _customInput(),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Ημερομηνία',
                ),
                readOnly: true,
                controller: _dateController,
                onTap: () => _selectDate(context, dateNow),
              ),
              SizedBox(height: 30.0),
              RaisedButton(
                color: Color.fromRGBO(50, 60, 107, 1),
                child: Text(
                  'Αποθήκευση',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if(_formKey.currentState.validate()) {
                    if (_currentType == '1') {
                      await MeasurementDatabaseService(uid: user.uid)
                          .createPressureData(
                          _currentPressureHigh + '/' + _currentPressureLow + ' mmHg',
                          (_currentDate == null)
                              ? DateFormat('yyyy/MM/dd – HH:mm').format(dateNow)
                              : DateFormat('yyyy/MM/dd – HH:mm').format(
                              _currentDate)
                      );
                    }
                    else if (_currentType == '2') {
                      await MeasurementDatabaseService(uid: user.uid)
                          .createGlucoseData(
                          _currentGlucose + ' mg/dl',
                          (_currentDate == null)
                              ? DateFormat('yyyy/MM/dd – HH:mm').format(dateNow)
                              : DateFormat('yyyy/MM/dd – HH:mm').format(
                              _currentDate)
                      );
                    }
                    else {
                      await MeasurementDatabaseService(uid: user.uid)
                          .createTemperatureData(
                          _currentTemperature + ' C',
                          (_currentDate == null)
                              ? DateFormat('yyyy/MM/dd – HH:mm').format(dateNow)
                              : DateFormat('yyyy/MM/dd – HH:mm').format(
                              _currentDate)
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
