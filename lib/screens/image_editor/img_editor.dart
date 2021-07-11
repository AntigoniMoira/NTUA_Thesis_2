import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';

import 'package:med_reminder/screens/image_editor/crop_editor_helper.dart';
import 'package:med_reminder/screens/image_editor/common_widget.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:med_reminder/screens/image_editor/watermark.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:med_reminder/shared/constants.dart';
import 'package:med_reminder/services/med_db.dart';



class ImageEditorDemo extends StatefulWidget {
  @override
  _ImageEditorDemoState createState() => _ImageEditorDemoState();
}

class _ImageEditorDemoState extends State<ImageEditorDemo> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
  GlobalKey<ExtendedImageEditorState>();
  final GlobalKey<PopupMenuButtonState<ExtendedImageCropLayerCornerPainter>>
  popupMenuKey =
  GlobalKey<PopupMenuButtonState<ExtendedImageCropLayerCornerPainter>>();
  bool _cropping = false;

  ExtendedImageCropLayerCornerPainter _cornerPainter;

  Map data = {};
  String imagePath;
  String barcode;

  @override
  void initState() {
    _cornerPainter = const ExtendedImageCropLayerPainterNinetyDegreesCorner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    imagePath = data['imagePath'];
    barcode =  data['barcode'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Επεξεργασία Φωτογραφίας'),
        centerTitle: true,
        backgroundColor: dark_blue,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              _cropImage();
            },
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: File(imagePath) != null
              ? ExtendedImage.memory(
            File(imagePath).readAsBytesSync(),
            fit: BoxFit.contain,
            mode: ExtendedImageMode.editor,
            enableLoadState: true,
            extendedImageEditorKey: editorKey,
            initEditorConfigHandler: (ExtendedImageState state) {
              return EditorConfig(
                  maxScale: 8.0,
                  cropRectPadding: const EdgeInsets.all(20.0),
                  hitTestSize: 20.0,
                  cornerPainter: _cornerPainter,
                  initCropRectType: InitCropRectType.imageRect
              );
            },
          )
              : ExtendedImage.asset(
            'assets/images/logontua.png',
            fit: BoxFit.contain,
            mode: ExtendedImageMode.editor,
            enableLoadState: true,
            extendedImageEditorKey: editorKey,
            initEditorConfigHandler: (ExtendedImageState state) {
              return EditorConfig(
                  maxScale: 8.0,
                  cropRectPadding: const EdgeInsets.all(20.0),
                  hitTestSize: 20.0,
                  cornerPainter: _cornerPainter,
                  initCropRectType: InitCropRectType.imageRect
              );
            },
          ),
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
        color: dark_blue,
        shape: const CircularNotchedRectangle(),
        child: ButtonTheme(
          minWidth: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              FlatButtonWithIcon(
                icon: const Icon(Icons.flip),
                label: const Text(
                  'Flip',
                  style: TextStyle(fontSize: 10.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  editorKey.currentState.flip();
                },
              ),
              FlatButtonWithIcon(
                icon: const Icon(Icons.rotate_left),
                label: const Text(
                  'Rotate Left',
                  style: TextStyle(fontSize: 8.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  editorKey.currentState.rotate(right: false);
                },
              ),
              FlatButtonWithIcon(
                icon: const Icon(Icons.rotate_right),
                label: const Text(
                  'Rotate Right',
                  style: TextStyle(fontSize: 8.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  editorKey.currentState.rotate(right: true);
                },
              ),
              FlatButtonWithIcon(
                icon: const Icon(Icons.restore),
                label: const Text(
                  'Reset',
                  style: TextStyle(fontSize: 10.0),
                ),
                textColor: Colors.white,
                onPressed: () {
                  editorKey.currentState.reset();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cropImage() async {
    if (_cropping) {
      return;
    }
    String msg = '';
    try {
      _cropping = true;

      //await showBusyingDialog();

      Uint8List fileData;

      ///delay due to cropImageDataWithDartLibrary is time consuming on main thread
      ///it will block showBusyingDialog
      ///if you don't want to block ui, use compute/isolate,but it costs more time.
      //await Future.delayed(Duration(milliseconds: 200));

      ///if you don't want to block ui, use compute/isolate,but it costs more time.
      fileData = Uint8List.fromList(
          await cropImageDataWithDartLibrary(state: editorKey.currentState));

      await _saveImage(fileData, imagePath);

      Uint8List watermarkImg = await AddWatermark(imgPath: imagePath).AddToImg();
      Uint8List finalImg = await testCompressList(watermarkImg);

      await _saveImage(finalImg, imagePath);

      await uploadAndUpdateDB (barcode, imagePath);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => First(med: newMed)),
      // );
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);
    } catch (e, stack) {
      msg = 'save failed: $e\n $stack';
      print(msg);
    }

    showToast(msg);
    _cropping = false;
  }

  Future<Uint8List> testCompressList(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 1920,
      minWidth: 1080,
      quality: 75,
      rotate: 0,
    );
    print('Compress:');
    print(list.length);
    print(result.length);
    return result;
  }

  Future<void> _saveImage(Uint8List uint8List, String filePath,
      {Function success, Function fail}) async {
    String tempPath = filePath;
    File image = File(tempPath);
    bool isExist = await image.exists();
    if (isExist) await image.delete();
    File(tempPath).writeAsBytes(uint8List).then((_) {
      if (success != null) success();
    });
  }

}