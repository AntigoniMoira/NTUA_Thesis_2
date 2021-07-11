import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class StorageService {

  String imgPath; //main barcode

  StorageService({this.imgPath});

  Future<String> uploadImg() async {

    File _imageFile =  File(imgPath);
    String fileName = basename(_imageFile.path);
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('meds/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    // taskSnapshot.ref.getDownloadURL().then(
    //       (value) => print("Done: $value"),
    // );
    return taskSnapshot.ref.getDownloadURL();
  }

}