import 'package:flutter/material.dart';
import 'package:med_reminder/models/doctor.dart';
import 'package:med_reminder/models/user.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/screens/doctors/doctors_form.dart';

class NewDoctor extends StatefulWidget {

  @override
  _NewDoctorState createState() => _NewDoctorState();
}

class _NewDoctorState extends State<NewDoctor> {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    final DoctorData emptyDoctor = DoctorData(
      doctorid: '',
      name: '',
      specialty: '',
      mobile: '',
      phone: '',
      email: '',
      address: ''
    );

    return  Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromRGBO(225, 230, 233, 1),
        // drawer: NavBar(),
        appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(50, 60, 107, 1),
        elevation: 0.0,
        title: Text('Καταχώρηση Ιατρού'),
        ),
        body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
        child: DoctorForm(emptyDoctor, 'new'),
      )
    );
  }
}