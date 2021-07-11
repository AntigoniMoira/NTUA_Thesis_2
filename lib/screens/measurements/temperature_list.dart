import 'package:flutter/material.dart';
import 'package:med_reminder/screens/measurements/temperature_tile.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/models/measurement.dart';

class TemperatureList extends StatefulWidget {
  @override
  _TemperatureListState createState() => _TemperatureListState();
}

class _TemperatureListState extends State<TemperatureList> {
  @override
  Widget build(BuildContext context) {

    final temperatures = Provider.of<List<TemperatureData>>(context) ?? [];

      return ListView.builder(
        itemCount: temperatures.length,
        itemBuilder: (context, index) {
          return TemperatureTile(temperature: temperatures[index]);
        },
      );
  }
}
