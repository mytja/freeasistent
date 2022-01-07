import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freeasistent/api/api.dart';
import 'package:freeasistent/colors.dart';
import 'package:freeasistent/timetable.dart';
import 'package:intl/intl.dart';

class AbsencesAPI {
  AbsencesAPI({required this.user_data});

  final UserData user_data;

  Future<Widget> getAbsences() async {
    var response = await Dio().get("$eAsUrl/m/absences",
        options: Options(headers: {
          ...WebPayload,
          'Authorization': 'Bearer ${this.user_data.access_token}',
          'x-child-id': '${this.user_data.id}',
        }));
    List absences = response.data["items"];
    List<Widget> absencesWidgets = [];
    for (Map event in absences) {
      bool isExcused = event["not_excused_count"] == 0;
      bool isManaged = event["state"] == "managed";
      DateTime date = DateTime.parse(event["date"]);
      List<Widget> hours = [];
      for (var i in event["hours"]) {
        hours.add(
          ListTile(
            leading: CircleAvatar(
              child: Icon(i["state"] != "managed"
                  ? (i["state"] == "excused" ? Icons.check : Icons.cancel)
                  : Icons.help),
            ),
            title: Text("${i["class_short_name"]} - ${i["class_name"]}"),
            subtitle: Text(i["state"] != "managed"
                ? (i["state"] == "excused" ? "Opravičeno" : "Neopravičeno")
                : "Še ni opravičeno"),
          ),
        );
      }
      absencesWidgets.add(
        Card(
          child: ExpansionTile(
            title: ListTile(
              leading: CircleAvatar(
                child: Icon(isManaged
                    ? (isExcused ? Icons.check : Icons.cancel)
                    : Icons.help),
              ),
              title: Text(
                DateFormat('EEEE, dd.MM.yyyy').format(date),
              ),
              subtitle: Text(
                "Število zamujenih ur ${event["missing_count"]}, od tega ${event["excused_count"]} opravičenih in ${event["not_excused_count"]} neopravičenih",
              ),
            ),
            children: hours,
          ),
        ),
      );
    }
    return ListView(
      children: absencesWidgets,
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
    );
  }
}
