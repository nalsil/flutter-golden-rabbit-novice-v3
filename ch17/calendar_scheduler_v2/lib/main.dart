import 'package:calendar_scheduler_v2/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:calendar_scheduler_v2/database/drift_database.dart';
import 'package:get_it/get_it.dart';
import 'package:calendar_scheduler_v2/provider/schedule_provider.dart';
import 'package:calendar_scheduler_v2/repository/schedule_repository.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = LocalDatabase();

  GetIt.I.registerSingleton<LocalDatabase>(database);

  final repository = ScheduleRepository();
  final scheduleProvider = ScheduleProvider(repository: repository);

  runApp(
    ChangeNotifierProvider(
      create: (context) => scheduleProvider,
      child: MaterialApp(home: HomeScreen()),
    ),
  );
}
