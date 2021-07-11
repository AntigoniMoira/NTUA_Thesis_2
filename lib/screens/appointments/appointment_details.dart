import 'package:flutter/material.dart';
import 'package:med_reminder/models/appointment.dart';
import 'package:med_reminder/shared/constants.dart';

class AppointmentDetails extends StatelessWidget {

  final AppointmentData appointment;
  AppointmentDetails( this.appointment );

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              'ΟΝΟΜΑ ΙΑΤΡΟΥ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              appointment.doctorsname,
              style: dataStyle
          ),
          SizedBox(height: 20.0),
          Text(
              'ΕΙΔΙΚΟΤΗΤΑ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              appointment.specialty,
              style: dataStyle
          ),
          SizedBox(height: 20.0),
          Text(
              'ΗΜΕΡΟΜΗΝΙΑ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              appointment.date,
              style: dataStyle
          ),
          SizedBox(height: 20.0),
          Text(
              'ΔΙΕΥΘΥΝΣΗ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              appointment.address,
              style: dataStyle
          ),
          SizedBox(height: 20.0),
          Text(
              'ΣΗΜΕΙΩΣΗ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              appointment.note,
              style: dataStyle
          ),
          SizedBox(height: 20.0),
        ]
    );
  }
}
