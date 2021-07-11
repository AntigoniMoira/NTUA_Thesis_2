import 'package:flutter/material.dart';
import 'package:med_reminder/models/med.dart';
import 'package:med_reminder/screens/meds/add_med/third.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:med_reminder/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/services/med_db.dart';
import 'package:weekday_selector/weekday_selector.dart';

class Second extends StatefulWidget {

  final NewMed med;
  Second({Key key, @required this.med}) : super(key: key);

  @override
  _SecondState createState() => _SecondState();
}

class _SecondState extends State<Second> {

  final _formKey = GlobalKey<FormState>();

  // form values
  String _currentSymptom = '';
  String _currentMeal = 'Πριν το φαγητό';
  String _currentUnits = 'χάπι(α)';
  String _currentDosage = '0.00';
  String _currentPeriodicity = '1';
  String _currentdaysX = '3';
  String _currentCircleX = '21';
  String _currentCircleY = '7';
  final values = List.filled(7, false);

  @override

  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    NewMed med = widget.med;

    Widget _customDays() {
      switch(_currentPeriodicity) {
        case '3': {
          return Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text("Ημέρες :"),
              ),
              Expanded(
                flex: 3,
                child: TextFormField(
                  initialValue: _currentdaysX,
                  keyboardType: TextInputType.number,
                  onChanged: (val) => setState(() {
                    _currentdaysX = val;
                  }),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(" "),
              ),
            ],
          );
        }
        break;

        case '4': {
          return WeekdaySelector(
            shortWeekdays: ['Κ','Δ', 'Τ', 'Τ', 'Π', 'Π', 'Σ'],
            onChanged: (int day) {
              setState(() {
                final index = day % 7;
                values[index] = !values[index];
              });
            },
            values: values,
          );
        }
        break;

        case '5': {
          return Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(" X:"),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          initialValue: _currentCircleX,
                          keyboardType: TextInputType.number,
                          onChanged: (val) => setState(() {
                            _currentCircleX = val;
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(" "),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(" Y:"),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          initialValue: _currentCircleY,
                          keyboardType: TextInputType.number,
                          onChanged: (val) => setState(() {
                            _currentCircleY = val;
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ]
          );
        }
        break;

        default: {
          return Text('');
        }
        break;
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromRGBO(225, 230, 233, 1),
        // drawer: NavBar(),
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          backgroundColor: Color.fromRGBO(50, 60, 107, 1),
          elevation: 0.0,
          title: Text('Καταχώρηση Φαρμάκου - Βήμα 2'),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _currentSymptom,
                      decoration: const InputDecoration(
                        hintText: '(πχ πονοκέφαλος, καρδιά κλπ.)',
                        labelText: 'Σύμπτωμα',
                      ),
                      onChanged: (val) => setState(() {
                        _currentSymptom = val;
                      }),
                    ),
                    SizedBox(height: 10.0),
                    SelectFormField(
                      // type: dropdown, // or can be dialog
                      initialValue: 'Πριν το φαγητό',
                      labelText: 'Οδηγίες',
                      items: meal_items,
                      onChanged: (val) {
                        setState(() {
                          _currentMeal = val;
                        });
                      },
                    ),
                    SizedBox(height: 10.0),
                    SelectFormField(
                      // type: dropdown, // or can be dialog
                      initialValue: 'χάπι(α)',
                      labelText: 'Μονάδες',
                      items: units,
                      onChanged: (val) {
                        setState(() {
                          _currentUnits = val;
                        });
                      },
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      initialValue: _currentDosage,
                      decoration: const InputDecoration(
                        hintText: '',
                        labelText: 'Δοσολογία',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => setState(() {
                        _currentDosage = val;
                      }),
                    ),
                    SizedBox(height: 10.0),
                    SelectFormField(
                      // type: dropdown, // or can be dialog
                      initialValue: '1',
                      labelText: 'Περιοδικότητα',
                      items: period_items,
                      onChanged: (val) {
                        setState(() {
                          _currentPeriodicity = val;
                        });
                      },
                      // onSaved: (val) => print(val),
                    ),
                    SizedBox(height: 10.0),
                    _customDays(),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      child: Text('Επόμενο',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Color.fromRGBO(50, 60, 107, 1),
                      onPressed: () {
                        med.symptom = _currentSymptom;
                        med.meal = _currentMeal;
                        med.units = _currentUnits;
                        med.dosage = _currentDosage;
                        med.periodicity = int.parse(_currentPeriodicity);
                        med.daysX = int.parse(_currentdaysX);
                        med.daysXY = [int.parse(_currentCircleX), int.parse(_currentCircleY)];
                        med.daysWeek = values;

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Third(med: med)),
                        );
                      },
                    ),
                  ],
                )
            )
        )
    );
  }
}
