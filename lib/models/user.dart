class AppUser {

  final String uid;
  final String email;

  AppUser({ this.uid, this.email });

}

class UserProfile {

  final String uid;
  final String name;
  final String email;
  final String birthdate;
  final String gender;
  final int height;
  final double weight;
  int today_counter;
  List<dynamic> today_meds;
  List<dynamic> tokens;

  UserProfile({ this.uid, this.name, this.email, this.birthdate, this.gender, this.height, this.weight, this.today_counter, this.today_meds, this.tokens });

}

