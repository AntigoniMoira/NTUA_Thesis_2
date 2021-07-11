import 'package:flutter/material.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/services/user_db.dart';
import 'package:med_reminder/shared/loading.dart';
import 'package:provider/provider.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final _formKey = GlobalKey<FormState>();
  final List<String> genders = ['Γυναίκα', 'Άνδρας', 'Άλλο'];

  //form values
  String _currentName;
  String _currentBirthdate;
  String _currentGender;
  int _currentHeight;
  double _currentWeight;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    return StreamBuilder<UserProfile>(
        stream: UserDatabaseService(uid: user.uid).userProfile,
        builder: (context, snapshot) {
        if(snapshot.hasData) {

          UserProfile userProfile = snapshot.data;
          return Scaffold(
            backgroundColor: Color.fromRGBO(225, 230, 233, 1),
            // drawer: NavBar(),
            appBar: AppBar(
              // automaticallyImplyLeading: false,
              backgroundColor: Color.fromRGBO(50, 60, 107, 1),
              elevation: 0.0,
              title: Text('Προφίλ'),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.save),
              backgroundColor: Color.fromRGBO(50, 60, 107, 1),
              foregroundColor: Colors.white,
              onPressed: () async {
                if(_formKey.currentState.validate()) {
                  await UserDatabaseService(uid: user.uid).updateUserData(
                    _currentName ?? userProfile.name,
                    userProfile.email,
                    _currentBirthdate ?? userProfile.birthdate,
                    _currentGender ?? userProfile.gender,
                    _currentHeight ?? userProfile.height,
                    _currentWeight ?? userProfile.weight
                  );
                  Navigator.pop(context);
                }
              },
            ),
            body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
            child:Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                TextFormField(
                    initialValue: userProfile.name,
                    decoration: const InputDecoration(
                      // icon: Icon(Icons.person),
                      hintText: 'Ποιό είναι το όνομά σας;',
                      labelText: 'Όνομα',
                    ),
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    initialValue: userProfile.birthdate,
                    decoration: const InputDecoration(
                      // icon: Icon(Icons.person),
                      hintText: 'Ποιά είναι η ημερομηνία γέννησής σας;',
                      labelText: 'Ημερ. Γέννησης',
                    ),
                    validator: (val) =>
                      val.isEmpty
                          ? 'Please enter a name'
                          : null,
                    onChanged: (val) => setState(() => _currentBirthdate = val),
                  ),
                  SizedBox(height: 10.0),
                  DropdownButtonFormField(
                      decoration: const InputDecoration(
                        // icon: Icon(Icons.person),
                        hintText: 'Ποιά είναι η ημερομηνία γέννησής σας;',
                        labelText: 'Φύλο',
                      ),
                      value: _currentGender ?? userProfile.gender,
                      items: genders.map((gender) {
                        return DropdownMenuItem(
                          value: gender,
                          child: Text('$gender'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _currentGender = val),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                      initialValue: userProfile.height.toString(),
                      decoration: const InputDecoration(
                        // icon: Icon(Icons.person),
                        hintText: 'Ποιό είναι το ύψος σας σε εκατοστά;',
                        labelText: 'Ύψος (cm)',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => setState(() => _currentHeight = int.parse(val)),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    initialValue: userProfile.weight.toString(),
                    decoration: const InputDecoration(
                    // icon: Icon(Icons.person),
                    hintText: 'Ποιό είναι το βάρος σας σε κιλά;',
                    labelText: 'Βάρος (kg)',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => setState(() => _currentWeight = double.parse(val)),
                  ),
                ],
              ),
            ),
          )
          );
          } else {
            return Loading();
          }
        }


    );
  }
}
