import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:linkiesta/src/common/utils.dart';
import 'package:linkiesta/src/feed/model/news_article.dart';

class Preview extends StatelessWidget {
  final NewsArticle data;

  const Preview({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Hero(
      tag: data,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 8.0,
          sigmaY: 8.0,
        ),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusFromRadiusSize(10),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width / (isPortrait ? .3 : 2.5),
            child: ListView(
              padding: EdgeInsets.only(bottom: 8),
              shrinkWrap: true,
              children: <Widget>[
                ClipRRect(
                  borderRadius: borderRadiusFromRadiusSize(10),
                  child: CachedNetworkImage(
                    imageUrl: data.image,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    data.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data.description,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Text(
                    data.authors,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    child: Text(
                      "Apri".toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textColor: Theme.of(context).accentColor,
                    onPressed: () async {
                      if (await canLaunch(data.link)) {
                        await launch(data.link);
                      } else {
                        print("cannot launch");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
