import 'package:flutter/material.dart';
import 'package:med_reminder/screens/appointments/appointment_tile.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/models/appointment.dart';
import 'package:med_reminder/shared/constants.dart';

class AppointmentList extends StatefulWidget {
  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  @override
  Widget build(BuildContext context) {

    final appointments = Provider.of<List<AppointmentData>>(context) ?? [];

    if(appointments.length != 0) {
      return ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return AppointmentTile(appointment: appointments[index]);
        },
      );
    }
    else{
      return Container(
        margin: EdgeInsets.only(left: 40.0, top: 40.0, right: 40.0, bottom: 450.0),
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: dark_blue, // Set border color
                width: 3.0),   // Set border width
            borderRadius: BorderRadius.all(
                Radius.circular(30.0)), // Set rounded corner radius
            boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
        ),
        child: Text('Αποθηκεύστε εδώ τα ραντεβού με γιατρούς ή για εξετάσεις.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: light_blue,
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                  ),
                ),
      );
    }
  }
}
