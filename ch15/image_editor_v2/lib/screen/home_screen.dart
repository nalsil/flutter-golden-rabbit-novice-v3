import 'package:flutter/material.dart';
import 'package:image_editor_v2/component/main_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_editor_v2/component/footer.dart';
import 'dart:io';
import 'package:image_editor_v2/component/emoticon_sticker.dart';
import 'package:image_editor_v2/model/sticker_model.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:gal/gal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? image;
  Set<StickerModel> stickers = {};
  String? selectedId;
  GlobalKey imgKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          renderBody(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MainAppBar(
              onPickImage: onPickImage,
              onSaveImage: onSaveImage,
              onDeleteItem: onDeleteItem,
            ),
          ),
          if (image != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Footer(onEmotionTap: onEmotionTap),
            ),
        ],
      ),
    );
  }

  Widget renderBody() {
    if (image != null) {
      return RepaintBoundary(
        key: imgKey,
        child: InteractiveViewer(
          child: Positioned.fill(
            child: InteractiveViewer(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(File(image!.path), fit: BoxFit.cover),
                  ...stickers.map(
                    (sticker) => Center(
                      child: EmoticonSticker(
                        key: ObjectKey(sticker.id),
                        onTransform: () {
                          onTransform(sticker.id);
                        },
                        imgPath: sticker.imgPath,
                        isSelected: selectedId == sticker.id,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.grey),
          onPressed: onPickImage,
          child: Text("이미지 선택하기"),
        ),
      );
    }
  }

  void onTransform(String id) {
    setState(() {
      selectedId = id;
    });
  }

  void onEmotionTap(int index) async {
    setState(() {
      stickers = {
        ...stickers,
        StickerModel(id: Uuid().v4(), imgPath: 'asset/img/emoticon_$index.png'),
      };
    });
  }

  void onPickImage() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      this.image = image;
    });
  }

  void onSaveImage() async {
    try {
      RenderRepaintBoundary boundary =
          imgKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save to gallery using gal package
      await Gal.putImageBytes(pngBytes);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장되었습니다.')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 실패: $e')),
      );
    }
  }

  void onDeleteItem() async {
    setState(() {
      stickers = stickers.where((sticker) => sticker.id != selectedId).toSet();
    });
  }
}
