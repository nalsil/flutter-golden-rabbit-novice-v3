import 'package:calendar_scheduler_v2/model/schedule_model.dart';
import 'package:calendar_scheduler_v2/repository/auth_repository.dart';
import 'package:calendar_scheduler_v2/repository/schedule_repository.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ScheduleProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final ScheduleRepository scheduleRepository;

  String? accessToken;
  String? refreshToken;

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  Map<DateTime, List<ScheduleModel>> cache = {};

  ScheduleProvider({required this.scheduleRepository, required this.authRepository})
    : super() {
    getSchedules(date: selectedDate);
  }

  void getSchedules({required DateTime date}) async {
    final resp = await scheduleRepository.getSchedules(date: date);

    cache.update(date, (value) => resp, ifAbsent: () => resp);
    notifyListeners();
  }

  void createSchedule({required ScheduleModel schedule}) async {
    final targetDate = schedule.date;
    final uuid = Uuid();

    final tempId = uuid.v4();
    final newSchedule = schedule.copyWith(id: tempId);

    cache.update(
      targetDate,
      (value) =>
          [...value, newSchedule]
            ..sort((a, b) => a.startTime.compareTo(b.startTime)),
      ifAbsent: () => [newSchedule],
    );

    notifyListeners();

    try {
      final savedSchedule = await scheduleRepository.createSchedule(schedule: schedule);

      cache.update(
        targetDate,
        (value) =>
            [...value, schedule.copyWith(id: savedSchedule)]
              ..sort((a, b) => a.startTime.compareTo(b.startTime)),
        ifAbsent: () => [schedule],
      );
    } catch (e) {
      cache.update(
        targetDate,
        (value) => value.where((e) => e.id != tempId).toList(),
      );
    }

    notifyListeners();
  }

  void deleteSchedule({required DateTime date, required String id}) async {
    final targetSchedule = cache[date]!.firstWhere((e) => e.id == id);

    cache.update(
      date,
      (value) => value.where((e) => e.id != id).toList(),
      ifAbsent: () => [],
    );

    notifyListeners();

    try {
      await scheduleRepository.deleteSchedule(id: id);
    } catch (e) {
      cache.update(
        date,
        (value) =>
            [...value, targetSchedule]
              ..sort((a, b) => a.startTime.compareTo(b.startTime)),
      );
    }

    notifyListeners();
  }

  void changeSelectedDate({required DateTime date}) {
    selectedDate = date;
    notifyListeners();
  }

  updateTokens({String? refreshToken, String? accessToken}) {
    if (refreshToken != null) {
      this.refreshToken = refreshToken;
    }
    if (accessToken != null) {
      this.accessToken = accessToken;
    }
    notifyListeners();
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    final resp = await authRepository.register(
      email: email,
      password: password,
    );

    updateTokens(
      refreshToken: resp.refreshToken,
      accessToken: resp.accessToken,
    );
  }

  Future<void> login({required String email, required String password}) async {
    final resp = await authRepository.login(email: email, password: password);

    updateTokens(
      refreshToken: resp.refreshToken,
      accessToken: resp.accessToken,
    );
  }

  logout() {
    refreshToken = null;
    accessToken = null;
    cache = {};
    notifyListeners();
  }

  rotateToken({
    required String refreshToken,
    required bool isRefreshToken,
  }) async {
    if (isRefreshToken) {
      final token = await authRepository.rotateRefreshToken(
        refreshToken: refreshToken,
      );
      this.refreshToken = token;
    } else {
      final token = await authRepository.rotateAccessToken(
        refreshToken: refreshToken,
      );
      this.accessToken = token;
    }

    notifyListeners();
  }
}
