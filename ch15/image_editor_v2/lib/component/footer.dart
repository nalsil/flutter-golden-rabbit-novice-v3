import 'package:flutter/material.dart';

typedef OnEmotionTap = void Function(int id);

class Footer extends StatelessWidget {
  final OnEmotionTap onEmotionTap;

  const Footer({super.key, required this.onEmotionTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.9),
      height: 150,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            7,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () => onEmotionTap(index + 1),
                child: Image.asset(
                  'asset/img/emoticon_${index + 1}.png',
                  height: 100,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
