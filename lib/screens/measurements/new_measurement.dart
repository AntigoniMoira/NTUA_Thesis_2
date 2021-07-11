import 'package:flutter/material.dart';
import 'package:med_reminder/models/measurement.dart';
import 'package:med_reminder/models/user.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/screens/measurements/measurements_form.dart';

class NewMeasurement extends StatefulWidget {

  @override
  _NewMeasurementState createState() => _NewMeasurementState();
}

class _NewMeasurementState extends State<NewMeasurement> {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    return  Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromRGBO(225, 230, 233, 1),
        // drawer: NavBar(),
        appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(50, 60, 107, 1),
        elevation: 0.0,
        title: Text('Καταχώρηση Μέτρησης'),
        ),
        body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
        child: MeasurementForm(),
      )
    );
  }
}