import 'package:calendar_scheduler_v2/provider/schedule_provider.dart';
import 'package:calendar_scheduler_v2/repository/auth_repository.dart';
import 'package:calendar_scheduler_v2/repository/schedule_repository.dart';
import 'package:calendar_scheduler_v2/screen/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final scheduleRepository = ScheduleRepository();
  final authRepository = AuthRepository();
  final scheduleProvider = ScheduleProvider(
    scheduleRepository: scheduleRepository,
    authRepository: authRepository,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => scheduleProvider,
      child: MaterialApp(home: AuthScreen()),
    ),
  );
}
