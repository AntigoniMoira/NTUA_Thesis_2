import 'package:flutter/material.dart';
import 'package:med_reminder/models/med.dart';
import 'package:med_reminder/shared/constants.dart';

class MedDetails extends StatelessWidget {

  final MedData med;
  MedDetails( this.med );

  @override
  Widget build(BuildContext context) {

    Widget _customPeriodicity(MedData med) {
      switch(med.periodicity) {
        case 1: {
            return Text(
                'Κάθε μέρα',
                style: dataStyle
            );
        }
        break;
        case 2: {
          return Text(
              'Μόνο μια μέρα',
              style: dataStyle
          );
        }
        break;
        case 3: {
          return Text(
              'Κάθε ${med.daysX} ημέρες',
              style: dataStyle
          );
        }
        break;
        case 4: {
          return Text(
              'Κάθε ${daysWeekList (med.daysWeek)}',
              style: dataStyle
          );
        }
        break;
        case 5: {
          return Text(
              'Κύκλος: ${med.daysXY[0]} πρόσληψη, ${med.daysXY[1]} παύση',
              style: dataStyle
          );
        }
        break;
        default: {
          return Text('');
        }
        break;
      }
    }

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
              'ΔΙΑΡΚΕΙΑ ΑΓΩΓΗΣ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              med.dateStart + ' - ' + med.dateEnd,
              style: dataStyle
          ),
          SizedBox(height: 20.0),
          Text(
              'ΠΕΡΙΟΔΙΚΟΤΗΤΑ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          _customPeriodicity(med),
          SizedBox(height: 20.0),
          Text(
              'ΩΡΕΣ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              '${intakesList (med.timesperday, med.intaketime)}',
              style: dataStyle
          ),
          SizedBox(height: 20.0),
        ]
    );
  }
}
