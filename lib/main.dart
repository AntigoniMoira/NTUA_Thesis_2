import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:camera/camera.dart';
import 'package:med_reminder/models/user.dart';
import 'package:med_reminder/screens/appointments/appointments.dart';
import 'package:med_reminder/screens/appointments/new_appointment.dart';
import 'package:med_reminder/screens/assistants/assistants.dart';
import 'package:med_reminder/screens/assistants/new_assistant.dart';
import 'package:med_reminder/screens/authenticate/register.dart';
import 'package:med_reminder/screens/authenticate/sign_in.dart';
import 'package:med_reminder/screens/doctors/doctors.dart';
import 'package:med_reminder/screens/doctors/new_doctor.dart';
import 'package:med_reminder/screens/image_editor/img_editor.dart';
import 'package:med_reminder/screens/meds/meds.dart';
import 'package:med_reminder/screens/notes/new_note.dart';
import 'package:med_reminder/screens/notes/notes.dart';
import 'package:med_reminder/screens/prescriptions/new_prescription.dart';
import 'package:med_reminder/screens/prescriptions/prescriptions.dart';
import 'package:med_reminder/screens/profile/profile.dart';
import 'package:med_reminder/screens/measurements/measurements.dart';
import 'screens/measurements/new_measurement.dart';
import 'package:med_reminder/screens/wrapper.dart';
import 'package:med_reminder/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cron/cron.dart';
import 'package:med_reminder/services/med_db.dart';
import 'package:med_reminder/models/med.dart';
import 'package:med_reminder/services/user_db.dart';
import 'package:med_reminder/services/appointment_db.dart';
import 'package:med_reminder/services/prescription_db.dart';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import 'package:med_reminder/screens/meds/take_picture.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


final FlutterLocalNotificationsPlugin localNotification =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  //Notifications start
  // await _configureLocalTimeZone();
  // var androidInitialize = new AndroidInitializationSettings("@mipmap/ic_launcher");
  // var iOSInitialize = new IOSInitializationSettings();
  // var initializationSettings = new InitializationSettings(
  //     android: androidInitialize, iOS: iOSInitialize
  // );
  // localNotification.initialize(initializationSettings);


  //Notifications end


  runApp(MultiProvider(
    providers: [
      StreamProvider<AppUser>.value(value: AuthService().user,),
      // StreamProvider<UserProfile>.value(value: UserDatabaseService(uid: user.uid).userProfile,),
    ],
    child: MaterialApp(
      // theme: ThemeData(fontFamily: 'Jura'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('fr')
      ],
      routes: {
        '/': (context) => Notification(),
        '/signin': (context) => SignIn(),
        '/register': (context) => Register(),
        '/profile': (context) => Profile(),
        '/doctors': (context) => Doctors(),
        '/newdoctor': (context) => NewDoctor(),
        '/assistants': (context) => Assistants(),
        '/newassistant': (context) => NewAssistant(),
        '/notes': (context) => Notes(),
        '/newnote': (context) => NewNote(),
        '/prescriptions': (context) => Prescriptions(),
        '/newprescription': (context) => NewPrescription(),
        '/appointments': (context) => Appointments(),
        '/newappointment': (context) => NewAppointment(),
        '/meds': (context) => Meds(),
        '/measurements': (context) => Measurements(),
        '/newmeasurement': (context) => NewMeasurement(),
        '/takepicture': (context) =>
            TakePictureScreen(
              // Pass the appropriate camera to the TakePictureScreen widget.
              camera: firstCamera,
            ),
        '/editpicture': (context) => ImageEditorDemo(),
      },
    ),
  ));
}

class Notification extends StatefulWidget {
  Notification({Key key}) : super(key: key);

  @override
  NotificationState createState() => NotificationState();
}

class NotificationState extends State<Notification> {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        //this callback happens when you are in the app and notification is received
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        //this callback happens when you launch app after a notification received
        Navigator.pushNamed(context, message['screen']);
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        //this callbakc happens when you open the app after a notification received AND
        //app was running in the background
        print("onResume: $message");
        Navigator.pushNamed(context, message['screen']);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper();
  }
}



// Future<void> _configureLocalTimeZone() async {
//   const MethodChannel platform =
//   MethodChannel('antmoira/med_reminder_notifications');
//   tz.initializeTimeZones();
//   final String timeZoneName = await platform.invokeMethod('getTimeZoneName');
//   tz.setLocalLocation(tz.getLocation(timeZoneName));
// }
//
//
// Future<void> _showNotification(DateTime scheduledNotificationDateTime, int id, String title, String body) async {
//   final androidDetailes = AndroidNotificationDetails(
//       'alarm_notif',
//       'alarm_notif',
//       'Channel for Alarm notification',
//       icon: "@drawable/app_notif_icon",
//       // sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
//       // largeIcon: DrawableResourceAndroidBitmap("@drawable/app_notif_icon"),
//       importance: Importance.high
//   );
//
//   final iosDetails = IOSNotificationDetails();
//   final generalNotificationDetails = NotificationDetails(android: androidDetailes, iOS: iosDetails);
//   await _configureLocalTimeZone();
//   await localNotification.zonedSchedule(
//       id,
//       title,
//       body,
//       // tz.TZDateTime.now(tz.local).add(const Duration(hours: 8)),
//       tz.TZDateTime.from(scheduledNotificationDateTime, tz.local,),
//       generalNotificationDetails,
//       androidAllowWhileIdle: true,
//       // payload: DateFormat("HH:mm").format(scheduledNotificationDateTime),
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime);
//   print(scheduledNotificationDateTime);
// }