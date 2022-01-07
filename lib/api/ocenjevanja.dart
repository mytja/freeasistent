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
    var responsePast = await Dio().get("$eAsUrl/m/evaluations?filter=past",
        options: Options(headers: {
          ...WebPayload,
          'Authorization': 'Bearer ${this.user_data.access_token}',
          'x-child-id': '${this.user_data.id}',
        }));
    List bivsaOcenjevanja = responsePast.data["items"];
    List ocenjevanja = response.data["items"];
    List<Widget> events = [];
    events.add(Center(
        child: Text(
      "Ocenjevanja",
      style: TextStyle(fontSize: 30),
    )));
    for (var event in ocenjevanja) {
      events.add(
        Card(
          child: ExpansionTile(
            title: ListTile(
              title: Text(event["course"]),
              subtitle: Text(event["subject"]),
            ),
            children: [
              Text(event["type_name"]),
              Text(
                event["date"],
                style: TextStyle(decorationThickness: 5),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      );
    }
    events.add(Divider());
    events.add(Center(
        child: Text(
      "Pretekla ocenjevanja",
      style: TextStyle(fontSize: 30),
    )));
    for (var event in bivsaOcenjevanja) {
      events.add(
        Card(
          child: ExpansionTile(
            title: ListTile(
              title: Text(event["course"]),
              subtitle: Text(event["subject"]),
            ),
            children: [
              Text(event["type_name"]),
              Text(
                event["date"],
                style: TextStyle(decorationThickness: 5),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      );
    }
    return events;
  }
}
