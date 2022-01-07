import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freeasistent/api/api.dart';
import 'package:freeasistent/api/timetable.dart';
import 'package:freeasistent/timetable.dart';

Future<List<String>> getSubjects(UserData userData) async {
  final Timetable timetable = Timetable(user_data: userData);
  final DateTime today = DateTime.now();
  DateTime monday = today.subtract(Duration(days: today.weekday - 1));
  DateTime sunday =
      today.add(Duration(days: DateTime.daysPerWeek - today.weekday + 7));
  final List<Meeting> meetings = await timetable.getTimetable(monday, sunday);
  List<String> subjectIds = [];
  for (var i in meetings) {
    if (!subjectIds.contains(i.subjectId)) {
      subjectIds.add(i.subjectId);
    }
  }
  return subjectIds;
}

class HomeworkAPI {
  HomeworkAPI({required this.user_data});

  final UserData user_data;

  Future<List<Widget>> getHomework() async {
    List<String> subjectIds = await getSubjects(this.user_data);
    List<Widget> widgets = [];
    for (var i in subjectIds) {
      print(i);
      var response = await Dio().get("$eAsUrl/m/homework/classes/$i",
          options: Options(headers: {
            ...WebPayload,
            'Authorization': 'Bearer ${this.user_data.access_token}',
            'x-child-id': '${this.user_data.id}',
          }));
      print(response.data);
      var data = response.data["items"];
      try {
        for (var i in data) {
          var response = await Dio().get("$eAsUrl/m/homework/${i['id']}",
              options: Options(headers: {
                ...WebPayload,
                'Authorization': 'Bearer ${this.user_data.access_token}',
                'x-child-id': '${this.user_data.id}',
              }));
          widgets.add(
            Card(
              child: ExpansionTile(
                title: ListTile(
                  title: Text(i["subject"]),
                  subtitle: Text(i["title"]),
                ),
                children: <Widget>[
                  Text(
                    'Do ${i["deadline"]}',
                  ),
                  Text(
                    "Vpisal ${response.data["author"]}, dne ${i["date"]}",
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        }
      } catch (e) {}
    }

    return widgets;
  }
}
