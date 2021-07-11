import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:med_reminder/NavBar.dart';
import 'package:med_reminder/models/med.dart';
import 'package:med_reminder/services/appointment_db.dart';
import 'package:med_reminder/services/prescription_db.dart';
import 'package:med_reminder/shared/constants.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';
import 'package:med_reminder/services/med_db.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/screens/home/home_tile.dart';
import 'package:med_reminder/services/old_notif.dart';
import 'package:med_reminder/services/user_db.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatePickerController _controller = DatePickerController();

  final format = DateFormat('dd/MM/yyyy');
  DateTime _selectedDate = DateTime.now();
  List<MedIntake> _medlist = [];

  void updateMedList(String useruid, DateTime date) async {
    List<MedIntake> newmedlist = await MedDatabaseService(uid: useruid).getDateMeds(date);
    setState(() {
      _medlist = newmedlist;
    });
  }


  @override
  void initState() {
    super.initState();
    String useruid = Provider.of<AppUser>(context, listen: false).uid;
    updateMedList(useruid, DateTime.now());

  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(225, 230, 233, 1),
      drawer: NavBar(),
      appBar: AppBar(
            // automaticallyImplyLeading: false,
            backgroundColor: Color.fromRGBO(50, 60, 107, 1),
            elevation: 0.0,
            title: Text('Αγωγή - ${format.format(_selectedDate)}'),
          ),
        body: SingleChildScrollView(
          child:Container(
            padding: EdgeInsets.all(20.0),
            color: grey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DatePicker(
                    DateTime.now(),
                    width: 60,
                    height: 80,
                    controller: _controller,
                    initialSelectedDate: DateTime.now(),
                    selectionColor: light_blue,
                    selectedTextColor: Colors.white,
                    locale : "el_GR",
                    onDateChange: (date) async {
                      updateMedList(user.uid, date);
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                  ListView.builder(
                    itemCount: _medlist.length,
                      shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return HomeTile(_medlist[index], _selectedDate);
                    },
                  )
              ],
            ),
          )
        )
    );
  }
}
