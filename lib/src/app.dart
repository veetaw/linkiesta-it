import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:linkiesta/src/common/utils.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:linkiesta/src/last_news/homepage.dart';
import 'package:linkiesta/src/feed/linkiesta.dart';
import 'package:url_launcher/url_launcher.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.subscribeToTopic("all");
    _firebaseMessaging.configure(
      onMessage: (message) async {
      },
      onLaunch: (message) async {
      },
      onResume: (message) async {
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();

    return ChangeNotifierProvider<FeedChangeNotifier>(
      builder: (context) => FeedChangeNotifier(),
      child: Scaffold(
        drawer: Drawer(
          child: Builder(
            builder: (context) {
              return ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 40,
                    ),
                    child: Text(
                      "Categorie",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                  buildListTile(
                    context,
                    title: "Ultime notizie",
                    type: FeedType.last,
                    icon: Icons.fiber_new,
                  ),
                  buildListTile(
                    context,
                    title: "Cultura",
                    type: FeedType.culture,
                    icon: Icons.school,
                  ),
                  buildListTile(
                    context,
                    title: "Economia",
                    type: FeedType.economy,
                    icon: Icons.trending_up,
                  ),
                  buildListTile(
                    context,
                    title: "Mondo",
                    type: FeedType.world,
                    icon: Icons.vpn_lock,
                  ),
                  buildListTile(
                    context,
                    title: "Innovazione",
                    type: FeedType.innovation,
                    icon: Icons.computer,
                  ),
                  buildListTile(
                    context,
                    title: "Italia",
                    type: FeedType.italy,
                    icon: Icons.home,
                  ),
                  buildListTile(
                    context,
                    title: "Politica",
                    type: FeedType.politcs,
                    icon: Icons.work,
                  ),
                  ListTile(
                    title: Text("Informazioni"),
                    leading: Icon(Icons.info),
                    onTap: () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (context) {
                          final TextStyle style = TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          );
                          return BackdropFilter(
                            filter: ui.ImageFilter.blur(
                              sigmaX: 8.0,
                              sigmaY: 8.0,
                            ),
                            child: Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: borderRadiusFromRadiusSize(10),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      "Informazioni",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text:
                                            "Tutti gli articoli appartengono al sito ",
                                        style: style,
                                        children: [
                                          TextSpan(
                                            text: " www.linkiesta.it ",
                                            style: style.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                ". Gli autori degli articoli sono creditati "
                                                "all'interno della preview."
                                                "\nQuesta applicazione",
                                            style: style,
                                          ),
                                          TextSpan(
                                            text: " NON ",
                                            style: style.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                "e' ufficiale, ma fatta da terzi come semplice "
                                                "aggregatore di rss. Il codice dell'applicazione "
                                                "e' disponibile su Github.",
                                            style: style,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                    ),
                                    FlatButton(
                                      child: Text(
                                        "Apri GitHub".toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      textColor: Theme.of(context).accentColor,
                                      onPressed: () async {
                                        var url =
                                            "https://github.com/veetaw/linkiesta-it";
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          print("cannot launch");
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
        body: ConnectivityWidget(
          offlineBanner: Container(
            width: double.infinity,
            child: Text(
              "Nessuna connessione",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          builder: (context, isConnected) => HomePage(),
        ),
      ),
    );
  }

  ListTile buildListTile(
    BuildContext context, {
    String title,
    FeedType type,
    IconData icon,
  }) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: () {
        Navigator.of(context).pop();
        Provider.of<FeedChangeNotifier>(context).feedType = type;
      },
    );
  }
}

class FeedChangeNotifier extends ChangeNotifier {
  FeedType _type;

  FeedChangeNotifier({
    FeedType type = FeedType.last,
  }) : _type = type;

  FeedType get feedType => _type;
  set feedType(FeedType newType) {
    _type = newType;
    notifyListeners();
  }
}
