import 'package:calendar_scheduler_v2/component/main_calendar.dart';
import 'package:calendar_scheduler_v2/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler_v2/component/today_banner.dart';
import 'package:calendar_scheduler_v2/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:calendar_scheduler_v2/component/schedule_card.dart';
import 'package:get_it/get_it.dart';
import 'package:calendar_scheduler_v2/database/drift_database.dart';
import 'package:calendar_scheduler_v2/component/today_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
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
              onDaySelected: onDaySelected,
            ),
            SizedBox(height: 8),
            StreamBuilder<List<Schedule>>(
              stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
              builder: (context, snapshot) {
                return TodayBanner(
                  selectedDate: selectedDate,
                  count: snapshot.data?.length ?? 0,
                );
              },
            ),
            SizedBox(height: 8),
            TodayBanner(selectedDate: selectedDate, count: 0),
            SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<List<Schedule>>(
                stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container();
                  }

                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final schedule = snapshot.data![index];

                      return Dismissible(
                        key: ObjectKey(schedule.id),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (DismissDirection direction) {
                          GetIt.I<LocalDatabase>().removeSchedule(schedule.id);
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

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
