import 'package:flutter/material.dart';
import 'package:med_reminder/models/med.dart';
import 'package:med_reminder/screens/meds/add_med/second.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:med_reminder/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/services/med_db.dart';

class First extends StatefulWidget {

  final NewMed med;
  First({Key key, @required this.med}) : super(key: key);

  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = new TextEditingController();

  String _barcode = '';
  String _medimg = 'notfound';

  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is removed from the
  //   // widget tree.
  //   _nameController.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    _nameController.addListener(_printLatestValue);
  }

  _printLatestValue() async {
    print("Textfield value: ${_nameController.text}");
    MedInfo selectedMed  = await getMedImg(_nameController.text);
    setState(() {
      _barcode = selectedMed.barcode;
      _medimg = selectedMed.img;
    });
  }

  @override

  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    NewMed med = widget.med;

    Future<List> fetchData() async {
      String _inputText = _nameController.text;

      List _list = await MedDatabaseService(uid: user.uid)
          .medNames(_inputText);

      return _list;
    }


    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: grey,
        // drawer: NavBar(),
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          backgroundColor: dark_blue,
          elevation: 0.0,
          title: Text('Καταχώρηση Φαρμάκου - Βήμα 1'),
        ),
        body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
               children: <Widget>[
                 TextFieldSearch(
                   // initialList: dummyList,
                   label: "Όνομα Φαρμάκου",
                   controller: _nameController,
                   future: () {
                     return fetchData();
                   },
                 ),
                 SizedBox(height: 5.0),
                 Text('*πληκτρολογήστε το όνομα με κεφαλαίους-λατινικούς χαρακτήρες'),
                 SizedBox(height: 10.0),
                Builder(
                builder: (context) {
                  if (_medimg == '') {
                    return Column(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        ButtonTheme(
                            minWidth: 200.0,
                            height: 50.0,
                            child: RaisedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/takepicture', arguments: {
                                  'barcode': _barcode,
                                });
                              },
                              icon: Icon(Icons.camera_enhance),
                              label: Text('Προσθέστε φωτογρφία'),
                              color: dark_blue,
                              textColor: Colors.white,
                            )
                        ),
                      ],
                    );
                  }
                  else if(_medimg == 'notfound') {
                    return SizedBox(height: 20.0);
                  }
                  else {
                    return Image.network(
                        _medimg,
                        height: 200
                    );
                  }
                }
               ),
               SizedBox(height: 20.0),
               RaisedButton(
                   child: Text('Επόμενο',
                     style: TextStyle(color: Colors.white),
                   ),
                   color: Color.fromRGBO(50, 60, 107, 1),
                   onPressed: () {
                     med.name = _nameController.text;
                     // med.symptom = _currentSymptom;
                     // med.meal = _currentMeal;
                     // med.units = _currentUnits;
                     // med.dosage = _currentDosage;
                     // med.periodicity = int.parse(_currentPeriodicity);
                     // med.daysX = int.parse(_currentdaysX);
                     // med.daysXY = [int.parse(_currentCircleX), int.parse(_currentCircleY)];
                     // med.daysWeek = values;

                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => Second(med: med)),
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
