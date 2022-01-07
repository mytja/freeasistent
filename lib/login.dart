import 'package:flutter/material.dart';
import 'package:freeasistent/api/api.dart';
import 'package:freeasistent/main.dart';
import 'package:freeasistent/scaffoldwidget.dart';

class LoginDemo extends StatefulWidget {
  LoginDemo({this.useScaffold = false});

  final bool useScaffold;

  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  late TextEditingController _username;
  late TextEditingController _password;

  @override
  void initState() {
    _username = TextEditingController();
    _password = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Widget w = SingleChildScrollView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          const Text(
            "PRIJAVA v FreeAsistent",
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: _username,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Uporabniško ime'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            //padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Geslo'),
            ),
          ),
          const Divider(),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: TextButton(
              onPressed: () async {
                await login(_username.text, _password.text);
                Navigator.pushNamed(context, "/koledar");
              },
              child: Text(
                'Prijava',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        ],
      ),
    );
    if (widget.useScaffold) {
      return ScaffoldWidget(body: w);
    }
    return w;
  }
}
