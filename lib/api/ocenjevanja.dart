import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freeasistent/api/api.dart';
import 'package:freeasistent/colors.dart';

class OcenjevanjaAPI {
  OcenjevanjaAPI({required this.user_data});

  final UserData user_data;

  Future<List<Widget>> getExaminations() async {
    var response = await Dio().get("$eAsUrl/m/evaluations?filter=future",
        options: Options(headers: {
          ...WebPayload,
          'Authorization': 'Bearer ${this.user_data.access_token}',
          'x-child-id': '${this.user_data.id}',
        }));
    List ocenjevanja = response.data["items"];
    List<Widget> events = [];
    for (var event in ocenjevanja) {
      events.add(Card(
        child: Column(
          children: [
            Text(
              event["course"],
              style: TextStyle(fontSize: 30),
            ),
            Text(event["subject"]),
            Text(event["type_name"]),
            Text(
              event["date"],
              style: TextStyle(decorationThickness: 5),
            )
          ],
        ),
      ));
    }
    return events;
  }
}
