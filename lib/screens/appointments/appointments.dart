import 'package:flutter/material.dart';
import 'package:med_reminder/screens/appointments/appointment_list.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/models/appointment.dart';
import 'package:med_reminder/services/appointment_db.dart';

 class Appointments extends StatelessWidget {
   @override
   Widget build(BuildContext context) {

     final user = Provider.of<AppUser>(context);

     return StreamProvider<List<AppointmentData>>.value(
       value: AppointmentDatabaseService(uid: user.uid).appointments,
       child: Scaffold(
           backgroundColor: Color.fromRGBO(225, 230, 233, 1),
           appBar: AppBar(
             // automaticallyImplyLeading: false,
             backgroundColor: Color.fromRGBO(50, 60, 107, 1),
             elevation: 0.0,
             title: Text('Ραντεβού'),
           ),
           floatingActionButton: FloatingActionButton(
             child: Icon(Icons.add),
             backgroundColor: Color.fromRGBO(50, 60, 107, 1),
             foregroundColor: Colors.white,
             onPressed: () async {
               Navigator.pushNamed(context, '/newappointment');
             },
           ),
           body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/appointment-background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: AppointmentList()
           )
       ),
     );

   }
 }
