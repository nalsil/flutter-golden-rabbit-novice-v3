import 'package:flutter/material.dart';

class EmoticonSticker extends StatefulWidget {
  final VoidCallback onTransform;
  final String imgPath;
  final bool isSelected;

  const EmoticonSticker({
    super.key,
    required this.onTransform,
    required this.imgPath,
    required this.isSelected,
  });

  @override
  State<EmoticonSticker> createState() => _EmoticonStickerState();
}

class _EmoticonStickerState extends State<EmoticonSticker> {
  double scale = 1;
  double hTransform = 0;
  double vTransform = 0;
  double actualScale = 1;
  double lastFocalX = 0;
  double lastFocalY = 0;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translationValues(hTransform, vTransform, 0)
        * Matrix4.diagonal3Values(scale, scale, 1),
      child: Container(
        decoration: widget.isSelected
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(color: Colors.blue, width: 1.0),
              )
            : BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.transparent),
              ),
        child: GestureDetector(
          onTap: () {
            widget.onTransform();
          },
          onScaleStart: (ScaleStartDetails details) {
            lastFocalX = details.focalPoint.dx;
            lastFocalY = details.focalPoint.dy;
          },
          onScaleUpdate: (ScaleUpdateDetails details) {
            widget.onTransform();
            setState(() {
              scale = details.scale * actualScale;
              hTransform += details.focalPoint.dx - lastFocalX;
              vTransform += details.focalPoint.dy - lastFocalY;
              lastFocalX = details.focalPoint.dx;
              lastFocalY = details.focalPoint.dy;
            });
          },
          onScaleEnd: (ScaleEndDetails details) {
            actualScale = scale;
          },
          child: Image.asset(widget.imgPath),
        ),
      ),
    );
  }
}
