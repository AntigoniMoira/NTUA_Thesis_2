import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/models/med.dart';
import 'package:med_reminder/screens/meds/med_details.dart';
import 'package:med_reminder/services/med_db.dart';
import 'package:med_reminder/shared/constants.dart';
import 'package:provider/provider.dart';

class MedTile extends StatelessWidget {

  final MedData med;
  MedTile({ this.med });



  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    void _delete(BuildContext context, String medid) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext ctx) {
            return CupertinoAlertDialog(
              title: Text('Επιβεβαίωση'),
              content: Text('Σίγουρα επιθυμείτε την διαγραφή;'),
              actions: [
                CupertinoDialogAction(
                  onPressed: () async{
                    await MedDatabaseService(uid: user.uid).deleteMedData(medid);
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
        barrierLabel: "Φάρμακο", // label for barrier
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
                  "Φάρμακο",
                  style: TextStyle(color: Colors.black87, fontFamily: 'Overpass', fontSize: 20),
                ),
                elevation: 0.0
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: MedDetails(med),
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
                backgroundImage: AssetImage('assets/images/med-icon.png')
            ),
            // leading: ClipRRect(
            //   borderRadius: BorderRadius.circular(20.0),//or 15.0
            //   child: Container(
            //     height: 50.0,
            //     width: 50.0,
            //     color: Color(0xffFF0E58),
            //     child: Icon(Icons.volume_up, color: Colors.white, size: 50.0),
            //   ),
            // ),
            title: Text('${med.name}', overflow: TextOverflow.ellipsis),
            subtitle: Text('${med.dateStart} - ${med.dateEnd}'),
            trailing: PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 'details',
                    child: Text('Προβολή'),
                  ),
                  PopupMenuItem(
                    value: 'stop',
                    child: Text('Διακοπή Σήμερα'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Διαγραφή'),
                  )
                ];
              },
              onSelected: (String value) {
                switch(value) {
                  case 'delete': _delete(context, med.medid);
                  break;
                  case 'stop': MedDatabaseService(uid: user.uid).updateMedData(med.medid);
                  break;
                  default: _showDetailsPanel(value);
                  break;
                }
              },
            ),
            onTap: () =>  _showDetailsPanel('details'),
          ),
        )
    );
  }
}

