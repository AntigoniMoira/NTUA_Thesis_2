import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/models/measurement.dart';
import 'package:med_reminder/services/measurement_db.dart';
import 'package:med_reminder/shared/constants.dart';
import 'package:provider/provider.dart';

class GlucoseTile extends StatelessWidget {

  final GlucoseData glucose;
  GlucoseTile({ this.glucose });



  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    void _delete(BuildContext context, String glucoseid) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext ctx) {
            return CupertinoAlertDialog(
              title: Text('Επιβεβαίωση'),
              content: Text('Σίγουρα επιθυμείτε την διαγραφή;'),
              actions: [
                CupertinoDialogAction(
                  onPressed: () async{
                    await MeasurementDatabaseService(uid: user.uid).deleteGlucoseData(glucoseid);
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

    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            title: Text(glucose.value),
            subtitle: Text(glucose.date),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline,
                color: orange,
                size: 35.0,
              ),
              onPressed: () async {
                _delete(context, glucose.glucoseid);
              },
            ),
          ),
        )
    );
  }
}

