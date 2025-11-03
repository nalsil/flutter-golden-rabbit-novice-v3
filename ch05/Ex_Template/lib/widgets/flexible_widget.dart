import 'package:flutter/material.dart';

class FlexibleWidgetExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Flexible(
                // flex는 남은 공간을 차지할 비율을 의미합니다.
                // flex값을 값을 제공하지 않으면 기본값은 1입니다.
                flex: 1,

                // 파란색 Container
                child: Container(
                  color: Colors.blue,
                ),
              ),
              Flexible(
                flex: 1,

                // 빨간색 Container
                child: Container(
                  color: Colors.red,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
