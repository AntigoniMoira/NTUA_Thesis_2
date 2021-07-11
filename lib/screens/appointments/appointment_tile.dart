import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/models/appointment.dart';
import 'package:med_reminder/screens/appointments/appointment_details.dart';
import 'package:med_reminder/screens/appointments/appointments_form.dart';
import 'package:med_reminder/services/appointment_db.dart';
import 'package:med_reminder/shared/constants.dart';
import 'package:provider/provider.dart';

class AppointmentTile extends StatelessWidget {

  final AppointmentData appointment;
  AppointmentTile({ this.appointment });



  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    void _delete(BuildContext context, String appointmentid) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext ctx) {
            return CupertinoAlertDialog(
              title: Text('Επιβεβαίωση'),
              content: Text('Σίγουρα επιθυμείτε την διαγραφή;'),
              actions: [
                CupertinoDialogAction(
                  onPressed: () async{
                    await AppointmentDatabaseService(uid: user.uid).deleteAppointmentData(appointmentid);
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
        barrierLabel: "Ραντεβού", // label for barrier
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
                  "Ραντεβού",
                  style: TextStyle(color: Colors.black87, fontFamily: 'Overpass', fontSize: 20),
                ),
                elevation: 0.0
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: value == 'edit' ?  AppointmentForm( appointment, 'edit'):  AppointmentDetails( appointment),
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
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/images/appointment-icon.png')
            ),
            title: Text( appointment.date),
            subtitle: Text('${ appointment.specialty}\n${ appointment.doctorsname}', overflow: TextOverflow.ellipsis),
            isThreeLine: true,
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
              onSelected: (String value) => value == 'delete' ? _delete(context, appointment.appointmentid) : _showDetailsPanel(value),
            ),
            onTap: () =>  _showDetailsPanel('details'),
          ),
        )
    );
  }
}

