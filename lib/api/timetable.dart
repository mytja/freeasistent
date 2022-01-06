import 'package:dio/dio.dart';
import 'package:freeasistent/api/api.dart';
import 'package:freeasistent/colors.dart';
import 'package:freeasistent/timetable.dart';
import 'package:intl/intl.dart';

class Timetable {
  Timetable({required this.user_data});

  final UserData user_data;

  List<String> getDate(DateTime today, DateTime lastday) {
    DateTime monday = today.subtract(Duration(days: today.weekday - 1));
    DateTime sunday =
        lastday.add(Duration(days: DateTime.daysPerWeek - today.weekday));
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String start = formatter.format(monday);
    final String end = formatter.format(sunday);
    return [start, end];
  }

  List<DateTime> getTimeForEvent(Map event, List times) {
    String startId = event["time"]["from_id"].toString();
    String? startTime;
    for (var time in times) {
      if (time["id"].toString() == startId) {
        startTime = time["time"]["from"];
      }
    }
    DateTime start = DateTime.parse(event["time"]["date"]);
    List<String> timeHourMinute = startTime!.split(":");
    start = start.add(Duration(
        hours: int.parse(timeHourMinute[0]),
        minutes: int.parse(timeHourMinute[1])));

    String endId = event["time"]["to_id"].toString();
    String? endTime;
    for (var time in times) {
      if (time["id"].toString() == endId) {
        endTime = time["time"]["to"];
      }
    }
    DateTime end = DateTime.parse(event["time"]["date"]);
    List<String> timeHourMinuteEnd = endTime!.split(":");
    end = end.add(Duration(
        hours: int.parse(timeHourMinuteEnd[0]),
        minutes: int.parse(timeHourMinuteEnd[1])));

    return [start, end];
  }

  Future<List<Meeting>> getTimetable(DateTime today, DateTime lastday) async {
    final List<String> date = this.getDate(today, lastday);
    var response = await Dio()
        .get("$eAsUrl/m/timetable/weekly?from=${date[0]}&to=${date[1]}",
            options: Options(headers: {
              ...WebPayload,
              'Authorization': 'Bearer ${this.user_data.access_token}',
              'x-child-id': '${this.user_data.id}',
            }));
    List times = response.data["time_table"];
    List<Meeting> events = [];
    for (var event in response.data["school_hour_events"]) {
      List<DateTime> time = this.getTimeForEvent(event, times);
      String type = "";
      if (event["hour_special_type"] == "substitution") {
        type = "[N] ";
      } else if (event["hour_special_type"] == "exam") {
        type = "[T] ";
      } else if (event["hour_special_type"] == "pre-exam") {
        type = "[P] ";
      }
      events.add(Meeting(
        event["event_id"],
        event["subject"]["id"],
        type + event["subject"]["name"] + "\n" + event["teachers"][0]["name"],
        time[0],
        time[1],
        HexColor(event["color"]),
      ));
    }
    return events;
  }
}
