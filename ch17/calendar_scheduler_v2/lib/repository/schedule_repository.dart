import 'dart:async';
import 'dart:io';

import 'package:calendar_scheduler_v2/model/schedule_model.dart';
import 'package:dio/dio.dart';

class ScheduleRepository {
  final _dio = Dio();
  final _targetUrl =
      'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:3000/schedule';

  Future<List<ScheduleModel>> getSchedules({required DateTime date}) async {
    final response = await _dio.get(
      _targetUrl,
      queryParameters: {
        'date':
            '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}',
      },
    );

    return (response.data as List)
        .map((e) => ScheduleModel.fromJson(json: e))
        .toList();
  }

  Future<String> createSchedule({required ScheduleModel schedule}) async {
    final json = schedule.toJson();
    final response = await _dio.post(_targetUrl, data: json);

    return response.data?['id'];
  }

  Future<String> deleteSchedule({required String id}) async {
    final response = await _dio.delete(_targetUrl, data: {'id': id});

    return response.data?['id'];
  }
}
