import 'package:flutter/material.dart';
import 'package:med_reminder/screens/measurements/pressure_tile.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/models/measurement.dart';

class PressureList extends StatefulWidget {
  @override
  _PressureListState createState() => _PressureListState();
}

class _PressureListState extends State<PressureList> {
  @override
  Widget build(BuildContext context) {

    final pressures = Provider.of<List<PressureData>>(context) ?? [];

      return ListView.builder(
        itemCount: pressures.length,
        itemBuilder: (context, index) {
          return PressureTile(pressure: pressures[index]);
        },
      );
  }
}
