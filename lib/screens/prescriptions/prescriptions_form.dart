import 'package:flutter/material.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/models/prescription.dart';
import 'package:med_reminder/services/prescription_db.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PrescriptionForm extends StatefulWidget {

  final PrescriptionData prescription;
  PrescriptionForm( this.prescription);

  @override
  _PrescriptionFormState createState() => _PrescriptionFormState();
}

class _PrescriptionFormState extends State<PrescriptionForm> {

  final _formKey = GlobalKey<FormState>();
  final format = DateFormat('dd/MM/yyyy');
  TextEditingController _dateStartController = TextEditingController();
  TextEditingController _dateEndController = TextEditingController();


  // form values
  String _currentBarcode;
  DateTime _currentDateStart;
  DateTime _currentDateEnd;
  String _currentCategory;

  Future<void> _selectStartDate(BuildContext context) async {

      await showDatePicker(
          context: context,
          locale: const Locale("el", "GR"),
          initialDate: _currentDateStart ?? DateTime.now(),
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
          _currentDateStart = date;
          _dateStartController.text = format.format(_currentDateStart);
          _dateEndController.text = format.format(_currentDateEnd);
        });
      });
  }

  Future<void> _selectEndDate(BuildContext context) async {

    await showDatePicker(
        context: context,
        locale: const Locale("el", "GR"),
        initialDate: _currentDateEnd ?? DateTime.now(),
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
        _currentDateEnd = date;
        _dateEndController.text = format.format(_currentDateEnd);
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    PrescriptionData prescription = widget.prescription;

    // DateTime dateNow = new DateTime.now();

    return Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                initialValue: _currentBarcode ?? prescription.barcode,
                decoration: const InputDecoration(
                  hintText: 'Γράψτε τo barcode της συνταγής σας',
                  labelText: 'Barcode',
                ),
                keyboardType: TextInputType.number,
                validator: (val) =>
                val.length != 13
                    ? 'To barcode πρέπει να αποτελείται από 13 ψηφία.'
                    : null,
                onChanged: (val) => setState(() => _currentBarcode = val),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                initialValue: _currentCategory ?? prescription.category,
                decoration: const InputDecoration(
                  hintText: 'Γράψτε την κατηγορία φαρμάκων που αφορά η συνταγή.',
                  labelText: 'Κατηγορία',
                ),
                onChanged: (val) => setState(() => _currentCategory= val),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                // initialValue: 'Hello',
                decoration: const InputDecoration(
                  labelText: 'Ημερομηνία Έναρξης',
                ),
                readOnly: true,
                controller: _dateStartController,
                validator: (val) =>
                  val.isEmpty
                      ? 'Παρακαλώ επιλέξτε ημερομηνία.'
                      : null,
                onTap: () => _selectStartDate(context),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                // initialValue: 'Hello',
                decoration: const InputDecoration(
                  labelText: 'Ημερομηνία Λήξης',
                ),
                readOnly: true,
                controller: _dateEndController,
                validator: (val) =>
                  val.isEmpty
                      ? 'Παρακαλώ επιλέξτε ημερομηνία.'
                      : null,
                onTap: () => _selectEndDate(context),
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
                    await PrescriptionDatabaseService(uid: user.uid)
                        .createPrescriptionData(
                        _currentBarcode,
                        DateFormat('yyyy/MM/dd').format(_currentDateStart),
                        DateFormat('yyyy/MM/dd').format(_currentDateEnd),
                        _currentCategory
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ]
        )
    );

  }
}
