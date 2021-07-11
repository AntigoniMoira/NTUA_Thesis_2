import 'package:flutter/material.dart';
import 'package:med_reminder/models/med.dart';
import 'package:med_reminder/shared/constants.dart';

class HomeDetails extends StatelessWidget {

  final MedIntake med;
  final DateTime date;
  HomeDetails( this.med, this.date );

  @override
  Widget build(BuildContext context) {

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              'ΟΝΟΜΑ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              med.name,
              style: dataStyle
          ),
          SizedBox(height: 20.0),
          Builder(
            builder: (context) {
              if (med.image != '') {
                return Image.network(
                          med.image,
                          height: 200,
                      );
              }
              else {
                return SizedBox(height: 0.0);
              }
            }
          ),
          SizedBox(height: 20.0),
          Text(
              'ΣΎΜΠΤΩΜΑ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              med.symptom,
              style: dataStyle
          ),
          SizedBox(height: 20.0),
          Text(
              'ΦΑΓΗΤΟ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              med.meal,
              style: dataStyle
          ),
          SizedBox(height: 20.0),
          Text(
              'ΔΟΣΗ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              med.dosage + ' ' + med.units,
              style: dataStyle
          ),
          SizedBox(height: 20.0),
          Text(
              'ΩΡA',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              med.intaketime,
              style: dataStyle
          ),
          SizedBox(height: 20.0),
        ]
    );
  }
}
