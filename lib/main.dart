import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freeasistent/api.dart';
import 'package:freeasistent/login.dart';
import 'package:intl/intl.dart';

import 'package:timetable/timetable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final myDateController = DateController(
    // All parameters are optional and displayed with their default value.
    initialDate: DateTimeTimetable.today(),
    visibleRange: VisibleDateRange.week(startOfWeek: DateTime.monday),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {},
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("FreeAsistent"),
        ),
        body: FutureBuilder<UserData?>(
          future: getToken(),
          builder: (BuildContext context, AsyncSnapshot<UserData?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(height: 1);
            } else if (snapshot.hasError) {
              return LoginDemo();
            } else {
              if (snapshot.data == null) {
                return LoginDemo();
              }
              return Center(
                child: TimetableConfig<BasicEvent>(
                  // Required:
                  dateController: myDateController,
                  eventBuilder: (context, event) => BasicEventWidget(event),
                  child: MultiDateTimetable<BasicEvent>(),
                  // Optional:
                  eventProvider: (date) {
                    final DateFormat formatter = DateFormat('yyyy-MM-dd');
                    String from = formatter.format(date.start);
                    String to = formatter.format(date.end);
                    var response = await Dio()
                        .get("$eAsUrl/m/timetable/weekly?from=$from&to=$to",
                            options: Options(headers: {
                              ...MobilePayload,
                              'Authorization':
                                  'Bearer ${snapshot.data!.access_token}',
                              'x-child-id': '${snapshot.data!.id}',
                            }));
                    List<BasicEvent> events = [];
                    for (var i in response.data["school_hour_events"])
                      return BasicEvent(
                          id: id,
                          title: title,
                          backgroundColor: backgroundColor,
                          start: start,
                          end: end);
                  },
                  allDayEventBuilder: (context, event, info) =>
                      BasicAllDayEventWidget(event, info: info),
                  callbacks: TimetableCallbacks(
                      // onWeekTap, onDateTap, onDateBackgroundTap, onDateTimeBackgroundTap
                      ),
                  theme: TimetableThemeData(
                    context,
                    // startOfWeek: DateTime.monday,
                    // See the "Theming" section below for more options.
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
