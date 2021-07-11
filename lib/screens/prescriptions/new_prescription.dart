import 'package:flutter/material.dart';
import 'package:med_reminder/models/prescription.dart';
import 'package:med_reminder/models/user.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/screens/prescriptions/prescriptions_form.dart';

class NewPrescription extends StatefulWidget {

  @override
  _NewPrescriptionState createState() => _NewPrescriptionState();
}

class _NewPrescriptionState extends State<NewPrescription> {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    final PrescriptionData emptyPrescription = PrescriptionData(
      prescriptionid: '',
      barcode: '',
      datestart: '',
      dateend: '',
      category: ''
    );

    return  Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromRGBO(225, 230, 233, 1),
        // drawer: NavBar(),
        appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(50, 60, 107, 1),
        elevation: 0.0,
        title: Text('Καταχώρηση Συνταγής'),
        ),
        body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
        child: PrescriptionForm(emptyPrescription),
      )
    );
  }
}