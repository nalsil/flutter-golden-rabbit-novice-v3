import 'package:ex_template/widgets/column_widget.dart';
import 'package:ex_template/widgets/expanded_widget.dart';
import 'package:ex_template/widgets/flexible_widget.dart';
import 'package:ex_template/widgets/icon_button_widget.dart';
import 'package:ex_template/widgets/row_widget.dart';
import 'package:ex_template/widgets/stack_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          // child: RowWidgetExample(),
          // child: ColumnWidgetExample(),
          // child: FlexibleWidgetExample(),
          // child: ExpandedWidgetExample(),
          // child: StackWidgetExample(),
          child: IconButtonWidgetExample(),
        ),
      ),
    );
  }
}
