import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freeasistent/api/api.dart';
import 'package:freeasistent/api/timetable.dart';
import 'package:freeasistent/timetable.dart';

class GradesAPI {
  GradesAPI({required this.user_data});

  final UserData user_data;

  Future<List<Widget>> getGrades() async {
    final Timetable timetable = Timetable(user_data: this.user_data);
    final DateTime today = DateTime.now();
    DateTime monday = today.subtract(Duration(days: today.weekday - 1));
    DateTime sunday =
        today.add(Duration(days: DateTime.daysPerWeek - today.weekday + 7));
    final List<Meeting> meetings = await timetable.getTimetable(monday, sunday);
    List<Widget> widgets = [];
    List<String> subjectIds = [];
    for (var i in meetings) {
      if (!subjectIds.contains(i.subjectId)) {
        subjectIds.add(i.subjectId);
      }
    }
    for (var i in subjectIds) {
      print(i);
      var response = await Dio().get("$eAsUrl/m/grades/classes/$i",
          options: Options(headers: {
            ...WebPayload,
            'Authorization': 'Bearer ${this.user_data.access_token}',
            'x-child-id': '${this.user_data.id}',
          }));
      print(response.data);
      try {
        var data = response.data["semesters"][0]["grades"][0];
        widgets.add(
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    child: Text(data["value"]),
                  ),
                  title: Text(response.data["short_name"]),
                  subtitle: Text(response.data["name"]),
                ),
                Text(
                  'Povprečna ocena: ' + response.data["average_grade"],
                ),
                const SizedBox(height: 8),
                Text(
                  'Oceno vpisal ${data["inserted_by"]["name"]}, dne ${data["date"]}',
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      } catch (e) {}
    }

    return widgets;
  }
}