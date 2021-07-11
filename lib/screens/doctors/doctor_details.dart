import 'package:flutter/material.dart';
import 'package:med_reminder/models/doctor.dart';
import 'package:med_reminder/shared/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorDetails extends StatelessWidget {

  final DoctorData doctor;
  DoctorDetails( this.doctor );

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
              doctor.name,
              style: dataStyle
          ),
          SizedBox(height: 20.0),
          Text(
              'ΕΙΔΙΚΟΤΙΤΑ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              doctor.specialty,
              style: dataStyle
          ),
          SizedBox(height: 20.0),
          Text(
              'KINHTO',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                    doctor.mobile,
                    style: dataStyle,
                ),
                IconButton(
                    onPressed: () => {launch('tel:+30 ${doctor.mobile}')},
                    icon: Icon(Icons.phone),
                      color: light_blue,
                ),
              ]
          ),
          SizedBox(height: 20.0),
          Text(
              'ΣΤΑΘΕΡΟ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                  Text(
                        doctor.phone,
                        style: dataStyle,
                  ),
                  IconButton(
                        onPressed: () => {launch('tel:+30 ${doctor.phone}')},
                        icon: Icon(Icons.phone),
                        color: light_blue,
                  ),
            ]
          ),
          SizedBox(height: 20.0),
          Text(
              'EMAIL',
              style:titleStyle
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                  Text(
                        doctor.email,
                        style: dataStyle,
                  ),
                  IconButton(
                        onPressed: () => {launch('mailto:${doctor.email}')},
                        icon: Icon(Icons.email),
                        color: light_blue,
                  ),
            ]
          ),
          SizedBox(height: 20.0),
          Text(
              'ΔΙΕΥΘΥΝΣΗ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              doctor.address,
              style: dataStyle
          ),
          SizedBox(height: 20.0),
        ]
    );
  }
}
