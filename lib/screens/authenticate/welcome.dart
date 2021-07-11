import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  Color.fromRGBO(225, 230, 233, 1),
        body: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [
                // Divider(
                //   height: 20.0,
                //   color: Colors.grey,
                // ),
                Expanded(
                  child: Image.asset('assets/images/welcome.png'),
                ),
                ButtonTheme(
                    minWidth: 300.0,
                    height: 40.0,
                    child: RaisedButton(
                      color: Color.fromRGBO(50, 60, 107, 1),
                      child: Text(
                        'Εγγραφή',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                    )
                ),
                SizedBox(height: 50.0),
                RichText(
                  text: TextSpan(
                    text: 'Έχετε ήδη έναν λογαριασμό; ',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Σύνδεση ',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/signin');
                            },
                          style: TextStyle(
                            color: Color.fromRGBO(50, 60, 107, 1),
                            fontWeight: FontWeight.bold
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 150.0),
              ],
            )

        )
    );
  }
}
