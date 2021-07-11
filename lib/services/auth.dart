import 'package:firebase_auth/firebase_auth.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/services/user_db.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final Firestore _firestore = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  // create user obj based on FirebaseUser
  AppUser _userFromFirebaseUser(User user) {
    return user != null ? AppUser(uid: user.uid, email: user.email) : null;
  }

  //auth change user stream
  Stream<AppUser> get user {
    return _auth.authStateChanges()
        .map(_userFromFirebaseUser);
  }

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      String fcmToken = await _fcm.getToken();
      List<dynamic> tokenlist =  await UserDatabaseService(uid: user.uid).getTokens();
      if (!tokenlist.contains(fcmToken)) {
        tokenlist.add(fcmToken);
        await UserDatabaseService(uid: user.uid).updateTokens(tokenlist);
      }
      return _userFromFirebaseUser(user);
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      String fcmToken = await _fcm.getToken();
      //create a new document for the user with the uid
      await UserDatabaseService(uid: user.uid).initializeUserData(name, email, '1/1/1900', 'Άλλο', 170, 70.0, 0, [], [fcmToken]);
      return _userFromFirebaseUser(user);
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      String uid = await currentUid();
      String fcmToken = await _fcm.getToken();
      List<dynamic> tokenlist =  await UserDatabaseService(uid: uid).getTokens();
      if (tokenlist.contains(fcmToken)) {
        tokenlist.remove(fcmToken);
        await UserDatabaseService(uid: uid).updateTokens(tokenlist);
      }
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future currentUid() async {
    final user = await _auth.currentUser;
    final userid = user.uid;
    return userid;
  }
}