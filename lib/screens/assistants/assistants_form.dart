import 'package:flutter/material.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/models/assistant.dart';
import 'package:med_reminder/services/assistant_db.dart';
import 'package:provider/provider.dart';

class AssistantForm extends StatefulWidget {

  final AssistantData assistant;
  final String mode;
  AssistantForm( this.assistant, this.mode );

  @override
  _AssistantFormState createState() => _AssistantFormState();
}

class _AssistantFormState extends State<AssistantForm> {

  final _formKey = GlobalKey<FormState>();

  // form values
  String _currentName;
  String _currentRelationship;
  String _currentMobile;
  String _currentPhone;
  String _currentEmail;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    AssistantData assistantProfile = widget.assistant;
    String mode = widget.mode;

    return Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              // Text(
              //   'Επεξεργασία στοιχείων γιατρού',
              //   style: TextStyle(fontSize: 18.0),
              // ),
              SizedBox(height: 20.0),
              TextFormField(
                initialValue: _currentName ?? assistantProfile.name,
                decoration: const InputDecoration(
                  hintText: 'Ποιό είναι το όνομα του φροντιστή σας;',
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
                initialValue:  _currentRelationship ?? assistantProfile.relationship,
                decoration: const InputDecoration(
                  hintText: 'Ποιά είναι η σχέση σας; (πχ, κόρη, γιός, σύντροφος κλπ)',
                  labelText: 'Σχέση',
                ),
                onChanged: (val) => setState(() => _currentRelationship = val),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                initialValue: _currentMobile ?? assistantProfile.mobile,
                decoration: const InputDecoration(
                  hintText: 'Ποιό είναι το κινητό του φροντιστή σας;',
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
                initialValue: _currentPhone ?? assistantProfile.phone,
                decoration: const InputDecoration(
                  hintText: 'Ποιό είναι το σταθερό του φροντιστή σας;',
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
                initialValue: _currentEmail ?? assistantProfile.email,
                decoration: const InputDecoration(
                  hintText: 'Ποιό είναι το email του φροντιστή σας;',
                  labelText: 'Email',
                ),
                onChanged: (val) => setState(() => _currentEmail = val),
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
                      await AssistantDatabaseService(uid: user.uid)
                          .createAssistantData(
                          _currentName, _currentRelationship, _currentMobile,
                          _currentPhone, _currentEmail);
                    }
                    else{
                      await AssistantDatabaseService(uid: user.uid)
                          .updateAssistantData(assistantProfile.assistantid,
                          _currentName ?? assistantProfile.name, _currentRelationship ?? assistantProfile.relationship, _currentMobile ?? assistantProfile.mobile,
                          _currentPhone ?? assistantProfile.phone, _currentEmail ?? assistantProfile.email);
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
