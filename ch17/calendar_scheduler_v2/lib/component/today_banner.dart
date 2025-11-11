import 'package:calendar_scheduler_v2/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:calendar_scheduler_v2/provider/schedule_provider.dart';
import 'package:provider/provider.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDate;
  final int count;

  const TodayBanner({Key? key, required this.selectedDate, required this.count})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();

    final textStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );

    return Container(
      color: PRIMARY_COLOR,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일',
              style: textStyle,
            ),
            Row(
              children: [
                Text('$count개', style: textStyle),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    provider.logout();
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.logout, color: Colors.white, size: 16.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
