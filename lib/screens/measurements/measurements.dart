import 'package:flutter/material.dart';
import 'package:med_reminder/screens/measurements/pressure_list.dart';
import 'package:med_reminder/screens/measurements/glucose_list.dart';
import 'package:med_reminder/screens/measurements/temperature_list.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/models/measurement.dart';
import 'package:med_reminder/services/measurement_db.dart';
import 'package:med_reminder/shared/constants.dart';

 class Measurements extends StatelessWidget {

   @override
   Widget build(BuildContext context) {

     final user = Provider.of<AppUser>(context);


     return MultiProvider(
       providers: [
         StreamProvider<List<PressureData>>.value(value: MeasurementDatabaseService(uid: user.uid).pressures,),
         StreamProvider<List<GlucoseData>>.value(value: MeasurementDatabaseService(uid: user.uid).glucoses,),
         StreamProvider<List<TemperatureData>>.value(value: MeasurementDatabaseService(uid: user.uid).temperatures,),
       ],
       child: DefaultTabController(
         length: 3,
         child: Scaffold(
           appBar: AppBar(
             bottom: TabBar(
               tabs: [
                 Tab(text: 'Πίεση'),
                 Tab(text: 'Γλυκόζη'),
                 Tab(text: 'Θερμοκρασία'),
               ],
             ),
             backgroundColor: Color.fromRGBO(50, 60, 107, 1),
             elevation: 0.0,
             title: Text('Μετρήσεις'),
           ),
           floatingActionButton: FloatingActionButton(
             child: Icon(Icons.add),
             backgroundColor: Color.fromRGBO(50, 60, 107, 1),
             foregroundColor: Colors.white,
             onPressed: () async {
               Navigator.pushNamed(context, '/newmeasurement');
             },
           ),
           body: Container(
            color: grey,
            child: TabBarView(
             children: [
               PressureList(),
               GlucoseList(),
               TemperatureList(),
             ],
           ),
           )
         ),
       ),
     );

   }
 }
