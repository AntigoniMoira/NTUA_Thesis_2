import 'package:flutter/material.dart';
import 'package:med_reminder/models/prescription.dart';
import 'package:med_reminder/shared/constants.dart';

class PrescriptionDetails extends StatelessWidget {

  final PrescriptionData prescription;
  PrescriptionDetails( this.prescription );

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              'BARCODE',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              '#${prescription.barcode}',
              style: dataStyle
          ),
          SizedBox(height: 20.0),
          Text(
              'ΗΜΕΡΟΜΗΝΙΑ ΕΝΑΡΞΗΣ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              prescription.datestart,
              style: dataStyle
          ),
          SizedBox(height: 20.0),
          Text(
              'ΗΜΕΡΟΜΗΝΙΑ ΛΗΞΗΣ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              prescription.dateend,
              style: dataStyle
          ),
          SizedBox(height: 20.0),
          Text(
              'ΚΑΤΗΓΟΡΙΑ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              prescription.category,
              style: dataStyle
          ),
          SizedBox(height: 20.0),
        ]
    );
  }
}
