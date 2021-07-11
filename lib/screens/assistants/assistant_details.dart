import 'package:flutter/material.dart';
import 'package:med_reminder/models/assistant.dart';
import 'package:med_reminder/shared/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AssistantDetails extends StatelessWidget {

  final AssistantData assistant;
  AssistantDetails( this.assistant );

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
              assistant.name,
              style: dataStyle
          ),
          SizedBox(height: 20.0),
          Text(
              'ΣΧΕΣΗ',
              style: titleStyle
          ),
          SizedBox(height: 10.0),
          Text(
              assistant.relationship,
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
                  assistant.mobile,
                    style: dataStyle,
                ),
                IconButton(
                    onPressed: () => {launch('tel:+30 ${assistant.mobile}')},
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
                        assistant.phone,
                        style: dataStyle,
                  ),
                  IconButton(
                        onPressed: () => {launch('tel:+30 ${assistant.phone}')},
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
                    assistant.email,
                        style: dataStyle,
                  ),
                  IconButton(
                        onPressed: () => {launch('mailto:${assistant.email}')},
                        icon: Icon(Icons.email),
                        color: light_blue,
                  ),
            ]
          ),
          SizedBox(height: 20.0),
        ]
    );
  }
}
