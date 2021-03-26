import 'package:flutter/material.dart';
import 'package:isar_inspector/app_state.dart';
import 'package:isar_inspector/collection_table.dart';
import 'package:isar_inspector/filter_field.dart';
import 'package:isar_inspector/prev_next.dart';
import 'package:isar_inspector/sidebar.dart';
import 'package:provider/provider.dart';
import 'package:isar_inspector/error.dart';

import 'connect.dart';

void main() async {
  print('Connecting…');
  runApp(ChangeNotifierProvider(
    create: (_) => AppState(),
    child: IsarInspector(),
  ));
}

class IsarInspector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
        primaryColor: Colors.blue,
        accentColor: Colors.blue,
        cardColor: Color(0xff1f2128), // Color.fromARGB(255, 40, 41, 46),
        dividerColor: Color.fromARGB(255, 40, 41, 46),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            minimumSize: MaterialStateProperty.all(Size(100, 50)),
          ),
        ),
      ),
      home: Container(
        decoration: BoxDecoration(
          color: Color(0xff111216), //Color.fromARGB(255, 34, 36, 41),
          borderRadius: BorderRadius.circular(20),
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            extendBody: true,
            body: _buildApp(state),
          ),
        ),
      ),
    );
  }

  Widget _buildApp(AppState state) {
    return Padding(
      padding: EdgeInsets.only(top: 35, left: 20, bottom: 20, right: 20),
      child: Container(
        constraints: BoxConstraints.expand(),
        child: Stack(
          children: [
            if (!state.connected)
              ConnectPage()
            else ...[
              Positioned(
                top: 0,
                left: 250,
                right: 0,
                height: 80,
                child: FilterField(),
              ),
              Positioned(
                top: 90,
                left: state.sidebarExpanded ? 250 : 0,
                right: 0,
                bottom: 0,
                child: _buildTable(state),
              ),
            ],
            SizedBox(
              width: 230,
              child: Sidebar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(AppState state) {
    if (state.selectedCollection == null) {
      return Center(
        child: Text('No collection selected'),
      );
    } else if (state.error != null) {
      return Error();
    } else {
      return CollectionTable();
    }
  }
}
