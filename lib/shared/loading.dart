import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(50, 60, 107, 1),
      child: Center(
          child: SpinKitPouringHourglass(
            color: Color.fromRGBO(225, 230, 233, 1),
            size: 70.0,
          )
      ),
    );
  }
}