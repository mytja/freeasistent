import 'package:flutter/material.dart';
import 'package:freeasistent/absences.dart';
import 'package:freeasistent/api/api.dart';
import 'package:freeasistent/api/timetable.dart';
import 'package:freeasistent/grades.dart';
import 'package:freeasistent/homework.dart';
import 'package:freeasistent/login.dart';
import 'package:freeasistent/ocenjevanja.dart';
import 'package:freeasistent/scaffoldwidget.dart';
import 'package:freeasistent/timetable.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      title: 'FreeAsistent',
      initialRoute: "/koledar",
      routes: {
        "/koledar": (context) => MyHomePage(),
        "/ocenjevanja": (context) => Ocenjevanja(),
        "/ocene": (context) => Grades(),
        "/domacenaloge": (context) => Homework(),
        "/izostanki": (context) => Absences(),
        "/prijava": (context) => LoginDemo(useScaffold: true),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime today =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  DateTime lastday = DateTime.now()
      .add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday));

  Future<List<Meeting>> getEvents() async {
    UserData? data = await getToken();
    if (data != null) {
      final timetable = Timetable(user_data: data);
      return await timetable.getTimetable(this.today, this.lastday);
    }
    return [];
  }

  final CalendarController _calendarController = CalendarController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: FutureBuilder<List<Meeting>>(
        future: getEvents(),
        builder: (BuildContext context, AsyncSnapshot<List<Meeting>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/play_store_512.png",
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "FreeAsistent",
                    style: TextStyle(fontSize: 30),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return LoginDemo();
          } else {
            if (snapshot.data == null) {
              return LoginDemo();
            }
            print(snapshot.data);
            return Column(
              children: [
                Expanded(
                  child: SfCalendar(
                    controller: _calendarController,
                    initialSelectedDate: this.today.add(Duration(hours: 6)),
                    timeSlotViewSettings: TimeSlotViewSettings(
                      startHour: 6,
                      endHour: 16,
                    ),
                    view: CalendarView.workWeek,
                    firstDayOfWeek: DateTime.monday,
                    dataSource: MeetingDataSource(snapshot.data!),
                    onViewChanged: (ViewChangedDetails details) {
                      DateTime firstdate = details.visibleDates.first;
                      DateTime lastdate = details.visibleDates.last;
                      bool fd = this.today.month == firstdate.month &&
                          this.today.day == firstdate.day &&
                          this.today.year == firstdate.year;
                      bool ld = this.lastday.month == lastdate.month &&
                          this.lastday.day == lastdate.day &&
                          this.lastday.year == lastdate.year;
                      if (!fd && !ld) {
                        print("View changed");
                        Future.delayed(
                          Duration.zero,
                          () {
                            setState(() {
                              this.today = details.visibleDates.first;
                              this.lastday = details.visibleDates.last;
                            });
                          },
                        );
                      }
                    },
                  ),
                ),
                Text(
                  "[T] - test",
                ),
                Text(
                  "[O] - odpadla ura",
                ),
                Text(
                  "[P] - preverjanje",
                ),
                Text(
                  "[N] - nadomeščanje",
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
