import 'package:flutter/material.dart';
import 'package:soul_talk_v2/screen/home_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:soul_talk_v2/model/message_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env 파일 로드
  await dotenv.load(fileName: ".env");

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([MessageModelSchema], directory: dir.path);

  GetIt.I.registerSingleton<Isar>(isar);

  runApp(MaterialApp(home: HomeScreen()));
}
