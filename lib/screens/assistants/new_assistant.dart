import 'package:flutter/material.dart';
import 'package:med_reminder/models/assistant.dart';
import 'package:med_reminder/models/user.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/screens/assistants/assistants_form.dart';

class NewAssistant extends StatefulWidget {

  @override
  _NewAssistantState createState() => _NewAssistantState();
}

class _NewAssistantState extends State<NewAssistant> {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    final AssistantData emptyAssistant = AssistantData(
      assistantid: '',
      name: '',
      relationship: '',
      mobile: '',
      phone: '',
      email: ''
    );

    return  Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromRGBO(225, 230, 233, 1),
        // drawer: NavBar(),
        appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(50, 60, 107, 1),
        elevation: 0.0,
        title: Text('Καταχώρηση Φροντιστή'),
        ),
        body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
        child: AssistantForm(emptyAssistant, 'new'),
      )
    );
  }
}
