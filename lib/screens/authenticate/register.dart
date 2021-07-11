import 'package:flutter/material.dart';
import 'package:med_reminder/services/auth.dart';
import 'package:med_reminder/shared/constants.dart';
import 'package:med_reminder/shared/loading.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String name = '';
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        backgroundColor: Color.fromRGBO(225, 230, 233, 1),
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          backgroundColor: Color.fromRGBO(50, 60, 107, 1),
          elevation: 0.0,
          title: Text('Εγγραφή'),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
            child: Form(
                key: _formKey,
                child: Column(
                    children: <Widget>[
                      SizedBox(height: 15.0),
                      TextFormField(
                          decoration: textInputDecoration.copyWith(hintText: 'Όνομα'),
                          validator: (val) => val.isEmpty ? 'Πληκτρολογήστε το όνομά σας' : null,
                          onChanged: (val) {
                            setState(() => name = val);
                          }
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (val) => val.isEmpty ? 'Πληκτρολογήστε το email σας' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          }
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                          decoration: textInputDecoration.copyWith(hintText: 'Password'),
                          obscureText: true,
                          validator: (val) => val.length < 6 ? 'Απαιτούνται τουλάχιστον 6 χαρακτήρες' : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          }
                      ),
                      SizedBox(height: 20.0),
                      RaisedButton(
                        color: Color.fromRGBO(50, 60, 107, 1),
                        child: Text(
                          'Υποβολή',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if(_formKey.currentState.validate()) {
                            setState(() => loading = true);
                             dynamic result = await _auth.registerWithEmailAndPassword(name, email, password);
                             if(result == null){
                                setState(() {
                                  error = 'Παρακαλώ πληκτρολογείστε ένα έγκυρο email.';
                                  loading = false;
                                });
                             }
                             else {
                               Navigator.pop(context);
                             }
                          }
                        },
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style:TextStyle(color:Colors.red, fontSize: 14.0),
                      )
                    ]
                )
            )
        )
    );
  }
}
