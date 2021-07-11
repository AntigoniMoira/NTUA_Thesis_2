import 'package:flutter/material.dart';
import 'package:med_reminder/models/appointment.dart';
import 'package:med_reminder/models/user.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/screens/appointments/appointments_form.dart';

class NewAppointment extends StatefulWidget {

  @override
  _NewAppointmentState createState() => _NewAppointmentState();
}

class _NewAppointmentState extends State<NewAppointment> {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    final AppointmentData emptyAppointment = AppointmentData(
      appointmentid: '',
      doctorsname: '',
      specialty: '',
      address: '',
      date: ''
    );

    return  Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromRGBO(225, 230, 233, 1),
        // drawer: NavBar(),
        appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(50, 60, 107, 1),
        elevation: 0.0,
        title: Text('Καταχώρηση Ραντεβού'),
        ),
        body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
        child: AppointmentForm(emptyAppointment, 'new'),
      )
    );
  }
}