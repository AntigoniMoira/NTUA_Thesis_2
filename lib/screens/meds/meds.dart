import 'package:flutter/material.dart';
import 'package:med_reminder/screens/meds/add_med/first.dart';
import 'package:med_reminder/screens/meds/med_list.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/models/med.dart';
import 'package:med_reminder/services/med_db.dart';

 class Meds extends StatelessWidget {
   @override
   Widget build(BuildContext context) {

     final user = Provider.of<AppUser>(context);

     final NewMed newMed = NewMed(
       name: '',
       symptom: '',
       units: '',
       dosage: '',
       dateStart: '',
       dateEnd: '',
       periodicity: 1,
       daysX: 1,
       daysXY: [21,7],
       daysWeek: [],
       timesperday: 2,
       intaketime: ['00:00', '00:00'],
       meal: ''
     );

     return StreamProvider<List<MedData>>.value(
       value: MedDatabaseService(uid: user.uid).meds,
       child: Scaffold(
           backgroundColor: Color.fromRGBO(225, 230, 233, 1),
           appBar: AppBar(
             // automaticallyImplyLeading: false,
             backgroundColor: Color.fromRGBO(50, 60, 107, 1),
             elevation: 0.0,
             title: Text('Φάρμακα'),
           ),
           floatingActionButton: FloatingActionButton(
             child: Icon(Icons.add),
             backgroundColor: Color.fromRGBO(50, 60, 107, 1),
             foregroundColor: Colors.white,
             onPressed: () async {
               // Navigator.pushNamed(context, '/newmed');
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => First(med: newMed)),
               );
             },
           ),
           body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/med-background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: MedList()
           ),
       )
     );

   }
 }
