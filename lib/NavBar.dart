import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:med_reminder/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/services/user_db.dart';

class NavBar extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    void _logout(BuildContext context) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext ctx) {
            return CupertinoAlertDialog(
              title: Text('Επιβεβαίωση'),
              content: Text('Σίγουρα επιθυμείτε να αποσυνδεθείτε από την εφαρμογή;'),
              actions: [
                CupertinoDialogAction(
                  onPressed: () async{
                    await _auth.signOut();
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Ναι'),
                  isDefaultAction: true,
                  isDestructiveAction: true,
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Όχι'),
                  isDefaultAction: false,
                  isDestructiveAction: false,
                )
              ],
            );
          });
    }

    final user = Provider.of<AppUser>(context);
    // final profile = Provider.of<UserProfile>(context);
    // print('hello $profile');
    return StreamBuilder<UserProfile>(
      stream: UserDatabaseService(uid: user.uid).userProfile,
      builder: (context, snapshot) {
        if(snapshot.hasData) {

           UserProfile userProfile = snapshot.data;
              return Drawer(
                  child: ListView(
                    // Remove padding
                    padding: EdgeInsets.zero,
                    children: [
                      UserAccountsDrawerHeader(
                        accountName: Text(userProfile.name),
                        accountEmail: Text(userProfile.email),
                        arrowColor: Color.fromRGBO (255, 212, 82, 1),
                        // currentAccountPicture: CircleAvatar(
                        //   child: ClipOval(
                        //     child: Image.asset(
                        //       'assets/images/avatar5.png',
                        //       fit: BoxFit.cover,
                        //       width: 70,
                        //       height: 70,
                        //     ),
                        //   ),
                        //   backgroundColor: grey,
                        // ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO (255, 212, 82, 1),
                          image: DecorationImage(
                              // fit: BoxFit.fill,
                              image: AssetImage('assets/images/NavBar.png'),
                          ),
                        ),
                        onDetailsPressed:  () {
                          Navigator.pushNamed(context, '/profile');
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.fiber_manual_record),
                        title: Text('Φάρμακα'),
                        onTap: () => Navigator.pushNamed(context, '/meds'),
                      ),
                      ListTile(
                        leading: Icon(Icons.poll),
                        title: Text('Μετρήσεις'),
                        onTap: () => Navigator.pushNamed(context, '/measurements'),
                      ),
                      ListTile(
                        leading: Icon(Icons.note),
                        title: Text('Σημειώσεις'),
                        onTap: () => Navigator.pushNamed(context, '/notes'),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.add_circle_outline),
                        title: Text('Ιατροί'),
                        onTap: () => Navigator.pushNamed(context, '/doctors'),
                      ),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Φροντιστές'),
                        onTap: () => Navigator.pushNamed(context, '/assistants'),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.description),
                        title: Text('Συνταγές'),
                        onTap: () => Navigator.pushNamed(context, '/prescriptions'),
                      ),
                      ListTile(
                        leading: Icon(Icons.access_time),
                        title: Text('Ραντεβού'),
                        onTap: () =>  Navigator.pushNamed(context, '/appointments'),
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Αποσύνδεση'),
                        leading: Icon(Icons.exit_to_app),
                        onTap: () => _logout(context),
                      ),
                    ],
                  ),
                );
            } else {
              return Container();
            }
        }
    );
  }
}
