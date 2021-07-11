import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/models/med.dart';
import 'package:med_reminder/screens/home/home_details.dart';
import 'package:med_reminder/services/med_db.dart';
import 'package:med_reminder/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:med_reminder/screens/home/home.dart';
import 'package:med_reminder/services/user_db.dart';

class HomeTile extends StatelessWidget {

  final MedIntake med;
  final DateTime date;
  HomeTile( this.med, this.date );

  final format = DateFormat('yyyy/MM/dd');
  DateTime _datenow = DateTime.now();



  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    void _showDetailsPanel() {
      showGeneralDialog(
        context: context,
        barrierDismissible: false, // should dialog be dismissed when tapped outside
        barrierLabel: "Δόση Αγωγής", // label for barrier
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
                  "Δόση Αγωγής",
                  style: TextStyle(color: Colors.black87, fontFamily: 'Overpass', fontSize: 20),
                ),
                elevation: 0.0
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: HomeDetails(med, date),
            ),
          );
        },
      );
    }

    void _delete(BuildContext context) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext ctx) {
            return CupertinoAlertDialog(
              title: Text('Επιβεβαίωση'),
              content: Text('Σίγουρα πήρατε την δόση αυτού του φαρμάκου;'),
              actions: [
                CupertinoDialogAction(
                  onPressed: () async{
                    List<dynamic> deletelist =  await UserDatabaseService(uid: user.uid).getTodayMeds();
                    String timename = med.intaketime+med.name;
                    if (deletelist != null) {
                      deletelist.add(timename);
                      await UserDatabaseService(uid: user.uid).updateTodayMeds(deletelist);
                    }
                    // Navigator.of(ctx).pop();
                    // Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                          (Route<dynamic> route) => false,
                    );
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


    return (format.format(date) != format.format(_datenow)) ? Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 0.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                  '${med.intaketime}',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              radius: 25.0,
              backgroundColor: light_blue,
            ),
            title: Text('${med.name}', overflow: TextOverflow.ellipsis),
            subtitle: Text('${med.dosage}  ${med.units}'),
            onTap: () =>  _showDetailsPanel(),
          ),
        )
    ) : Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 0.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                '${med.intaketime}',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              radius: 25.0,
              backgroundColor: light_blue,
            ),
            title: Text('${med.name}', overflow: TextOverflow.ellipsis),
            subtitle: Text('${med.dosage}  ${med.units}'),
            trailing: IconButton(
              icon: Icon(Icons.check_circle_outline,
                color: orange,
                size: 35.0,
              ),
              onPressed: () async {
                _delete(context);
              },
            ),
            onTap: () =>  _showDetailsPanel(),
          ),
        )
    );
  }
}

