import 'package:flutter/material.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/models/doctor.dart';
import 'package:med_reminder/services/doctor_db.dart';
import 'package:provider/provider.dart';

class DoctorForm extends StatefulWidget {

  final DoctorData doctor;
  final String mode;
  DoctorForm( this.doctor, this.mode );

  @override
  _DoctorFormState createState() => _DoctorFormState();
}

class _DoctorFormState extends State<DoctorForm> {

  final _formKey = GlobalKey<FormState>();

  // form values
  String _currentName;
  String _currentSpecialty;
  String _currentMobile;
  String _currentPhone;
  String _currentEmail;
  String _currentAddress;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    DoctorData doctorProfile = widget.doctor;
    String mode = widget.mode;

    return Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                initialValue: _currentName ?? doctorProfile.name,
                decoration: const InputDecoration(
                  hintText: 'Ποιό είναι το όνομα του ιατρού σας;',
                  labelText: 'Όνομα',
                ),
                validator: (val) =>
                  val.isEmpty
                      ? 'Παρακαλώ εισάγετε ένα όνομα.'
                      : null,
                onChanged: (val) => setState(() => _currentName = val),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                initialValue:  _currentSpecialty ?? doctorProfile.specialty,
                decoration: const InputDecoration(
                  hintText: 'Ποιά είναι η ειδικότητα του ιατρού σας;',
                  labelText: 'Ειδικότητα',
                ),
                onChanged: (val) => setState(() => _currentSpecialty = val),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                initialValue: _currentMobile ?? doctorProfile.mobile,
                decoration: const InputDecoration(
                  hintText: 'Ποιό είναι το κινητό του/της ιατρού σας;',
                  labelText: 'Κινητό',
                ),
                keyboardType: TextInputType.number,
                validator: (val) =>
                  (val.length != 10 && val.length != 0)
                      ? 'Εισάγετε ένα έγκυρο νούμερο τηλεφώνου (10 ψηφία).'
                      : null,
                onChanged: (val) => setState(() => _currentMobile = val),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                initialValue: _currentPhone ?? doctorProfile.phone,
                decoration: const InputDecoration(
                  hintText: 'Ποιό είναι το σταθερό του/της ιατρού σας;',
                  labelText: 'Σταθερό',
                ),
                keyboardType: TextInputType.number,
                validator: (val) =>
                  (val.length != 10 && val.length != 0)
                      ? 'Εισάγετε ένα έγκυρο νούμερο τηλεφώνου (10 ψηφία).'
                      : null,
                onChanged: (val) => setState(() => _currentPhone = val),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                initialValue: _currentEmail ?? doctorProfile.email,
                decoration: const InputDecoration(
                  hintText: 'Ποιό είναι το email του/της ιατρού σας;',
                  labelText: 'Email',
                ),
                onChanged: (val) => setState(() => _currentEmail = val),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                initialValue: _currentAddress ?? doctorProfile.address,
                decoration: const InputDecoration(
                  hintText: 'Ποιά είναι η διεύθυνση του/της ιατρού σας;',
                  labelText: 'Διεύθυνση',
                ),
                onChanged: (val) => setState(() => _currentAddress = val),
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
                      await DoctorDatabaseService(uid: user.uid)
                          .createDoctorData(
                          _currentName, _currentSpecialty, _currentMobile,
                          _currentPhone, _currentEmail, _currentAddress);
                    }
                    else{
                      await DoctorDatabaseService(uid: user.uid)
                          .updateDoctorData(doctorProfile.doctorid,
                          _currentName ?? doctorProfile.name, _currentSpecialty ?? doctorProfile.specialty, _currentMobile ?? doctorProfile.mobile,
                          _currentPhone ?? doctorProfile.phone, _currentEmail ?? doctorProfile.email, _currentAddress ?? doctorProfile.address);
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
