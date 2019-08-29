import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as timeago;

import 'package:linkiesta/src/common/utils.dart';
import 'package:linkiesta/src/feed/model/news_article.dart';
import 'package:linkiesta/src/last_news/last_news_card.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    Key key,
    @required this.data,
    @required this.onTap,
    @required this.image,
  }) : super(key: key);

  final NewsArticle data;
  final OnClick onTap;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Hero(
      tag: data,
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16, top: 16),
        width: double.infinity,
        height: MediaQuery.of(context).size.height / (isPortrait ? 6.5 : 3),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTap(context, data),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: image,
                ),
                Expanded(
                  flex: isPortrait ? 4 : 6,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          data.title,
                          maxLines: isPortrait ? 5 : 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            buildCategoryTitle(context, data.category),
                            Text(
                              timeago.format(
                                data.pubDate,
                                locale: ui.window.locale.languageCode,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
