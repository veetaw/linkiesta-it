import 'package:flutter/material.dart';

import 'package:linkiesta/src/app.dart';
import 'package:timeago/timeago.dart' as timeago;

GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

void main() async {
  timeago.setLocaleMessages('it', timeago.ItMessages());
  timeago.setLocaleMessages('it_IT', timeago.ItMessages());

  runApp(
    MaterialApp(
      home: App(),
    ),
  );
}
