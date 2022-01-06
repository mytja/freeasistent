import 'package:flutter/material.dart';

class ScaffoldWidget extends StatefulWidget {
  ScaffoldWidget({Key? key, required this.body}) : super(key: key);

  final Widget body;

  @override
  ScaffoldWidgetState createState() => ScaffoldWidgetState();
}

class ScaffoldWidgetState extends State<ScaffoldWidget> {
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('FreeAsistent'),
            ),
            ListTile(
              title: const Text('Koledar'),
              onTap: () {
                Navigator.pushNamed(context, "/koledar");
              },
            ),
            ListTile(
              title: const Text('Ocenjevanja znanj'),
              onTap: () {
                Navigator.pushNamed(context, "/ocenjevanja");
              },
            ),
            ListTile(
              title: const Text('Moje ocene'),
              onTap: () {
                Navigator.pushNamed(context, "/ocene");
              },
            ),
            ListTile(
              title: const Text('Domače naloge'),
              onTap: () {
                Navigator.pushNamed(context, "/domacenaloge");
              },
            ),
            ListTile(
              title: const Text('Moji izostanki'),
              onTap: () {
                Navigator.pushNamed(context, "/izostanki");
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("FreeAsistent"),
      ),
      body: widget.body,
    );
  }
}
