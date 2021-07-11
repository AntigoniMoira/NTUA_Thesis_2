import 'package:flutter/material.dart';
import 'package:med_reminder/screens/measurements/glucose_tile.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/models/measurement.dart';

class GlucoseList extends StatefulWidget {
  @override
  _GlucoseListState createState() => _GlucoseListState();
}

class _GlucoseListState extends State<GlucoseList> {
  @override
  Widget build(BuildContext context) {

    final glucoses = Provider.of<List<GlucoseData>>(context) ?? [];

      return ListView.builder(
        itemCount: glucoses.length,
        itemBuilder: (context, index) {
          return GlucoseTile(glucose: glucoses[index]);
        },
      );
  }
}
