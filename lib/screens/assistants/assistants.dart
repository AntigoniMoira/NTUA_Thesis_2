import 'package:flutter/material.dart';
import 'package:med_reminder/screens/assistants/assistant_list.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/models/assistant.dart';
import 'package:med_reminder/services/assistant_db.dart';

 class Assistants extends StatelessWidget {
   @override
   Widget build(BuildContext context) {

     final user = Provider.of<AppUser>(context);

     return StreamProvider<List<AssistantData>>.value(
       value: AssistantDatabaseService(uid: user.uid).assistants,
       child: Scaffold(
           backgroundColor: Color.fromRGBO(225, 230, 233, 1),
           appBar: AppBar(
             // automaticallyImplyLeading: false,
             backgroundColor: Color.fromRGBO(50, 60, 107, 1),
             elevation: 0.0,
             title: Text('Φροντιστές'),
           ),
           floatingActionButton: FloatingActionButton(
             child: Icon(Icons.add),
             backgroundColor: Color.fromRGBO(50, 60, 107, 1),
             foregroundColor: Colors.white,
             onPressed: () async {
               Navigator.pushNamed(context, '/newassistant');
             },
           ),
           body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/assistant-background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: AssistantList()
           ),
     )
    );

   }
 }
