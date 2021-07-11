import 'package:flutter/material.dart';
import 'package:med_reminder/screens/prescriptions/prescription_list.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/models/prescription.dart';
import 'package:med_reminder/services/prescription_db.dart';

 class Prescriptions extends StatelessWidget {
   @override
   Widget build(BuildContext context) {

     final user = Provider.of<AppUser>(context);

     return StreamProvider<List<PrescriptionData>>.value(
       value: PrescriptionDatabaseService(uid: user.uid).prescriptions,
       child: Scaffold(
           backgroundColor: Color.fromRGBO(225, 230, 233, 1),
           appBar: AppBar(
             // automaticallyImplyLeading: false,
             backgroundColor: Color.fromRGBO(50, 60, 107, 1),
             elevation: 0.0,
             title: Text('Συνταγές'),
           ),
           floatingActionButton: FloatingActionButton(
             child: Icon(Icons.add),
             backgroundColor: Color.fromRGBO(50, 60, 107, 1),
             foregroundColor: Colors.white,
             onPressed: () async {
               Navigator.pushNamed(context, '/newprescription');
             },
           ),
           body: Container(
               decoration: BoxDecoration(
                 image: DecorationImage(
                   image: AssetImage('assets/images/prescription-background.jpg'),
                   fit: BoxFit.cover,
                 ),
               ),
               child: PrescriptionList()
           )
       ),
     );

   }
 }
