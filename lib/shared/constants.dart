import 'package:flutter/material.dart';

Color dark_blue = const Color.fromRGBO(50, 60, 107, 1);
Color light_blue = const Color.fromRGBO (110, 170, 173, 1);
Color grey = const Color.fromRGBO (225, 230, 233, 1);
Color orange = const Color.fromRGBO (250, 183, 0, 1);

const textInputDecoration = InputDecoration (
  fillColor:Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0)
  ),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.pink, width: 2.0)
  ),
);

const titleStyle = TextStyle(
    color: const Color.fromRGBO(137, 197, 205, 1),
    letterSpacing: 2.0
);

const dataStyle =  TextStyle(
    color: Color.fromRGBO(50, 60, 107, 1),
    letterSpacing: 2.0,
    fontSize: 20.0,
    fontWeight: FontWeight.bold
);

final List<Map<String, dynamic>> measurement_types = [
  {
    'value': '1',
    'label': 'Αρτηριακή Πίεση',
  },
  {
    'value': '2',
    'label': 'Γλυκόζη Αίματος',
  },
  {
    'value': '3',
    'label': 'Θερμοκρασία',
  },
];

final List<Map<String, dynamic>> period_items = [
  {
    'value': '1',
    'label': 'Κάθε μέρα',
  },
  {
    'value': '2',
    'label': 'Μόνο μια μέρα',
  },
  {
    'value': '3',
    'label': 'Κάθε Χ ημέρες',
  },
  {
    'value': '4',
    'label': 'Επιλεγμένες μέρες της εβδομάδας',
  },
  {
    'value': '5',
    'label': 'Κύκλος: Χ πρόσληψη, Υ παύση',
  },
];

final List<Map<String, dynamic>> meal_items = [
  {
    'value': 'Πριν το φαγητό',
    'label': 'Πριν το φαγητό',
  },
  {
    'value': 'Μετά το φαγητό',
    'label': 'Μετά το φαγητό',
  },
  {
    'value': 'Κατά την διάρκεια του φαγητού',
    'label': 'Κατά την διάρκεια του φαγητού',
  },
  {
    'value': 'Δεν έχει σημασία',
    'label': 'Δεν έχει σημασία',
  },
];

Map<String, String> iconsMap = {
  'χάπι(α)': '001-pills.png',
  'κάψουλα/ες': '004-meds.png',
  'κουταλάκι(α) του γλυκού': '009-spoon.png',
  'κουταλιά(ές) της σούπας': '009-spoon.png',
  'ένεση/εις': '003-syringe.png',
  'εισπνοή/ές': '011-inhaler.png',
  'εφαρμογή/ές': 'Phuc Tran',
  'σταγόνα/ες': '008-drop.png',
  'υπόθετο/α': '010-suppositories',
  'αμπούλα/ες': '007-ampoule.png',
  'σακουλάκι(α)': 'Phuc Tran',
  'mg': 'Phuc Tran',
  'mL': 'Phuc Tran',
  'UI': 'Phuc Tran',
};

final List<Map<String, dynamic>> units = [
  {
    'value': 'χάπι(α)',
    'label': 'χάπι(α)',
  },
  {
    'value': 'κάψουλα/ες',
    'label': 'κάψουλα/ες',
  },
  {
    'value': 'κουταλάκι(α) του γλυκού',
    'label': 'κουταλάκι(α) του γλυκού',
  },
  {
    'value': 'κουταλιά(ές) της σούπας',
    'label': 'κουταλιά(ές) της σούπας',
  },
  {
    'value': 'ένεση/εις',
    'label': 'ένεση/εις',
  },
  {
    'value': 'εισπνοή/ές',
    'label': 'εισπνοή/ές',
  },
  {
    'value': 'εφαρμογή/ές',
    'label': 'εφαρμογή/ές',
  },
  {
    'value': 'σταγόνα/ες',
    'label': 'σταγόνα/ες',
  },
  {
    'value': 'υπόθετο/α',
    'label': 'υπόθετο/α',
  },
  {
    'value': 'αμπούλα/ες',
    'label': 'αμπούλα/ες',
  },
  {
    'value': 'σακουλάκι(α)',
    'label': 'σακουλάκι(α)',
  },
  {
    'value': 'mg',
    'label': 'mg',
  },
  {
    'value': 'mL',
    'label': 'mL',
  },
  {
    'value': 'UI',
    'label': 'UI',
  },
];

final List<Map<String, dynamic>> timesperday = [
  {
    'value': '1',
    'label': '1 φορά την ημέρα',
  },
  {
    'value': '2',
    'label': '2 φορές την ημέρα',
  },
  {
    'value': '3',
    'label': '3 φορές την ημέρα',
  },
  {
    'value': '4',
    'label': '4 φορές την ημέρα',
  }
];

class MySelectionItem extends StatelessWidget {
  final String title;
  final bool isForList;

  const MySelectionItem({Key key, this.title, this.isForList = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: isForList
          ? Padding(
        child: _buildItem(context),
        padding: EdgeInsets.all(10.0),
      )
          : Card(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Stack(
          children: <Widget>[
            _buildItem(context),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.arrow_drop_down),
            )
          ],
        ),
      ),
    );
  }

  _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Text(title),
    );
  }
}

String daysWeekList (List<dynamic> days) {
  final greekDays = ['Κυριακή', 'Δευτέρα', 'Τρίτη', 'Τετάρτη', 'Πέμπτη', 'Παρασκευή', 'Σάββατο'];
  String dayslist = '';
  for(var i = 0; i<7; i++) {
    dayslist += days[i] ? '${greekDays[i]}, ' : '';
  }

  return dayslist.substring(0, dayslist.length - 2);
}

String intakesList (int timesperday, List<dynamic> hours) {
  String intakeslist = '';
  for(var i = 0; i<timesperday; i++) {
    intakeslist += '${hours[i]}, ';
  }

  return intakeslist.substring(0, intakeslist.length - 2);
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}