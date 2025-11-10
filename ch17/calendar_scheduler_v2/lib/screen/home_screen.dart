import 'package:calendar_scheduler_v2/component/main_calendar.dart';
import 'package:calendar_scheduler_v2/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler_v2/component/schedule_card.dart';
import 'package:calendar_scheduler_v2/component/today_banner.dart';
import 'package:calendar_scheduler_v2/const/colors.dart';
import 'package:calendar_scheduler_v2/database/drift_database.dart';
import 'package:calendar_scheduler_v2/provider/schedule_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

//class _HomeScreenState extends State<HomeScreen> {
class HomeScreen extends StatelessWidget {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();
    final selectedDate = provider.selectedDate;
    final schedules = provider.cache[selectedDate] ?? [];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            builder: (_) => ScheduleBottomSheet(selectedDate: selectedDate),
            isScrollControlled: true,
          );
        },
        child: Icon(Icons.add),
      ),

      body: SafeArea(
        child: Column(
          children: [
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelected: (selectedDate, focusedDate) =>
                  onDaySelected(selectedDate, focusedDate, context),
            ),
            SizedBox(height: 8),
            SizedBox(height: 8),
            TodayBanner(selectedDate: selectedDate, count: schedules.length),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final schedule = schedules[index];

                  return Dismissible(
                    key: ObjectKey(schedule.id),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (DismissDirection direction) {
                      provider.deleteSchedule(
                        date: selectedDate,
                        id: schedule.id,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8.0,
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: ScheduleCard(
                        startTime: schedule.startTime,
                        endTime: schedule.endTime,
                        content: schedule.content,
                      ),
                    ),
                  );
                },
              ),
            ),

            ScheduleCard(startTime: 12, endTime: 14, content: '프로그램 공부'),
          ],
        ),
      ),
    );
  }

  void onDaySelected(
    DateTime selectedDate,
    DateTime focusedDate,
    BuildContext context,
  ) {
    final provider = context.read<ScheduleProvider>();
    provider.changeSelectedDate(date: selectedDate);
    provider.getSchedules(date: selectedDate);
  }
}
