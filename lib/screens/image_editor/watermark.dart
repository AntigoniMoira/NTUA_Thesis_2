import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as ui;
import 'package:flutter/services.dart' show rootBundle;

class AddWatermark {

  String imgPath; //main barcode

  AddWatermark({this.imgPath});

  Future<Uint8List> AddToImg() async {

    ByteData bytes = await rootBundle.load('assets/images/logontua.png');

    Uint8List _watermarkImage = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    Uint8List _originalImage = await File(imgPath).readAsBytes();

    ui.Image originalImage = ui.decodeImage(_originalImage);
    ui.Image watermarkImage = ui.decodeImage(_watermarkImage);

    // add watermark over originalImage
    // initialize width and height of watermark image
    ui.Image image = ui.Image(30, 30);
    ui.drawImage(image, watermarkImage);

    // give position to watermark over image
    // originalImage.width - 160 - 25 (width of originalImage - width of watermarkImage - extra margin you want to give)
    // originalImage.height - 50 - 25 (height of originalImage - height of watermarkImage - extra margin you want to give)
    ui.copyInto(originalImage,image, dstX: originalImage.width - 30 - 5, dstY: originalImage.height - 30 - 5);


    // for adding text over image
    // Draw some text using 24pt arial font
    // 100 is position from x-axis, 120 is position from y-axis
    //ui.drawString(originalImage, ui.arial_24, 100, 120, 'Think Different');


    // Store the watermarked image to a File
    List<int> wmImage = ui.encodePng(originalImage);
    Uint8List _watermarkedImage = Uint8List.fromList(wmImage);
    return  _watermarkedImage;
  }

}