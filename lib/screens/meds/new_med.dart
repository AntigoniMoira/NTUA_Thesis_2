// import 'package:flutter/material.dart';
// import 'package:med_reminder/models/med.dart';
// import 'package:med_reminder/models/user.dart';
// import 'package:med_reminder/screens/meds/add_med/first.dart';
// import 'package:provider/provider.dart';
// import 'package:med_reminder/screens/meds/meds_form.dart';
//
// class NewMed extends StatefulWidget {
//
//   @override
//   _NewMedState createState() => _NewMedState();
// }
//
// class _NewMedState extends State<NewMed> {
//
//   @override
//   Widget build(BuildContext context) {
//
//     final user = Provider.of<AppUser>(context);
//
//     final NewMed emptyMed = NewMed(
//       barcode: '',
//       name: '',
//       img: ''
//     );
//
//     return  Scaffold(
//         resizeToAvoidBottomInset: true,
//         backgroundColor: Color.fromRGBO(225, 230, 233, 1),
//         // drawer: NavBar(),
//         appBar: AppBar(
//         // automaticallyImplyLeading: false,
//         backgroundColor: Color.fromRGBO(50, 60, 107, 1),
//         elevation: 0.0,
//         title: Text('Καταχώρηση Φαρμάκου - Όνομα'),
//         ),
//         body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
//         // child: MedForm(),
//           child: First(med: emptyMed)
//       )
//     );
//   }
// }