import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'timeofday.g.dart';

@HiveType(typeId: 101)
class TimeOfDay extends HiveObject {
  @HiveField(0)
  int hour;

  @HiveField(1)
  int minute;

  TimeOfDay({required this.hour, required this.minute});
}
