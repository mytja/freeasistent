import 'package:flutter/material.dart';
import 'package:freeasistent/api/absences.dart';
import 'package:freeasistent/api/api.dart';
import 'package:freeasistent/loading.dart';
import 'package:freeasistent/login.dart';
import 'package:freeasistent/scaffoldwidget.dart';

class Absences extends StatelessWidget {
  Future<Widget> getEvents() async {
    UserData? data = await getToken();
    if (data != null) {
      final ocenjevanja = AbsencesAPI(user_data: data);
      return await ocenjevanja.getAbsences();
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: FutureBuilder<Widget>(
        future: getEvents(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingIndicator();
          } else if (snapshot.hasError) {
            return LoginDemo();
          } else {
            if (snapshot.data == null) {
              return LoginDemo();
            }
            return snapshot.data!;
          }
        },
      ),
    );
  }
}
