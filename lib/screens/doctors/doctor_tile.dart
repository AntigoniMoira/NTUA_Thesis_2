import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/models/doctor.dart';
import 'package:med_reminder/screens/doctors/doctor_details.dart';
import 'package:med_reminder/screens/doctors/doctors_form.dart';
import 'package:med_reminder/services/doctor_db.dart';
import 'package:provider/provider.dart';

class DoctorTile extends StatelessWidget {

  final DoctorData doctor;
  DoctorTile({ this.doctor });



  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    void _delete(BuildContext context, String doctorid) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext ctx) {
            return CupertinoAlertDialog(
              title: Text('Επιβεβαίωση'),
              content: Text('Σίγουρα επιθυμείτε την διαγραφή;'),
              actions: [
                CupertinoDialogAction(
                  onPressed: () async{
                    await DoctorDatabaseService(uid: user.uid).deleteDoctorData(doctorid);
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Ναι'),
                  isDefaultAction: true,
                  isDestructiveAction: true,
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Όχι'),
                  isDefaultAction: false,
                  isDestructiveAction: false,
                )
              ],
            );
          });
    }

    void _showDetailsPanel(String value) {
      showGeneralDialog(
        context: context,
        barrierDismissible: false, // should dialog be dismissed when tapped outside
        barrierLabel: "Στοιχεία Ιατρού", // label for barrier
        transitionDuration: Duration(milliseconds: 500), // how long it takes to popup dialog after button click
        pageBuilder: (_, __, ___) { // your widget implementation
          return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                leading: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                    }
                ),
                title: Text(
                  "Στοιχεία Iατρού",
                  style: TextStyle(color: Colors.black87, fontFamily: 'Overpass', fontSize: 20),
                ),
                elevation: 0.0
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: value == 'edit' ? DoctorForm(doctor, 'edit'): DoctorDetails(doctor),
            ),
          );
        },
      );
    }

    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            leading: CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.brown[100],
                backgroundImage: AssetImage('assets/images/doctor-icon.png')
            ),
            title: Text(doctor.name),
            subtitle: Text('${doctor.specialty}'),
            trailing: PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 'details',
                    child: Text('Προβολή'),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Επεξεργασία'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Διαγραφή'),
                  )
                ];
              },
              onSelected: (String value) => value == 'delete' ? _delete(context, doctor.doctorid) : _showDetailsPanel(value),
            ),
            onTap: () =>  _showDetailsPanel('details'),
          ),
        )
    );
  }
}

