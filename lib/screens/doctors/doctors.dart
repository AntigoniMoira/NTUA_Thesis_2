import 'package:flutter/material.dart';
import 'package:med_reminder/screens/doctors/doctor_list.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/models/doctor.dart';
import 'package:med_reminder/services/doctor_db.dart';

 class Doctors extends StatelessWidget {
   @override
   Widget build(BuildContext context) {

     final user = Provider.of<AppUser>(context);

     return StreamProvider<List<DoctorData>>.value(
       value: DoctorDatabaseService(uid: user.uid).doctors,
       child: Scaffold(
           backgroundColor: Color.fromRGBO(225, 230, 233, 1),
           appBar: AppBar(
             // automaticallyImplyLeading: false,
             backgroundColor: Color.fromRGBO(50, 60, 107, 1),
             elevation: 0.0,
             title: Text('Ιατροί'),
           ),
           floatingActionButton: FloatingActionButton(
             child: Icon(Icons.add),
             backgroundColor: Color.fromRGBO(50, 60, 107, 1),
             foregroundColor: Colors.white,
             onPressed: () async {
               // DoctorDatabaseService(uid: user.uid).createDoctorData('text', 'text', 'text', 'text', 'text', 'text');
               Navigator.pushNamed(context, '/newdoctor');
             },
           ),
           body: Container(
               decoration: BoxDecoration(
                 image: DecorationImage(
                   image: AssetImage('assets/images/doctor-background.jpg'),
                   fit: BoxFit.cover,
                 ),
               ),
               child: DoctorList()
           )
          ),
     );

   }
 }
