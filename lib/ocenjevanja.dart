import 'package:flutter/material.dart';
import 'package:freeasistent/api/api.dart';
import 'package:freeasistent/api/ocenjevanja.dart';
import 'package:freeasistent/loading.dart';
import 'package:freeasistent/login.dart';
import 'package:freeasistent/scaffoldwidget.dart';

class Ocenjevanja extends StatelessWidget {
  DateTime today =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  DateTime lastday = DateTime.now()
      .add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday));

  Future<List<Widget>> getEvents() async {
    UserData? data = await getToken();
    if (data != null) {
      final ocenjevanja = OcenjevanjaAPI(user_data: data);
      return await ocenjevanja.getExaminations();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: FutureBuilder<List<Widget>>(
        future: getEvents(),
        builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingIndicator();
          } else if (snapshot.hasError) {
            return LoginDemo();
          } else {
            if (snapshot.data == null) {
              return LoginDemo();
            }
            return ListView(
              children: snapshot.data!,
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
            );
          }
        },
      ),
    );
  }
}
