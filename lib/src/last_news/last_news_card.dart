import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:linkiesta/src/common/utils.dart';

import 'package:linkiesta/src/feed/model/news_article.dart';

typedef OnClick = Function(BuildContext, NewsArticle);

class LastNewsCard extends StatelessWidget {
  static const double _kPadding = 16;
  static const double _kBorderRadius = 20;

  const LastNewsCard({
    Key key,
    @required this.data,
    @required this.onTap,
  }) : super(key: key);

  final NewsArticle data;
  final OnClick onTap;

  @override
  Widget build(BuildContext context) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double cardHeight =
        MediaQuery.of(context).size.height / (isPortrait ? 2.5 : 1.5) +
            _kPadding;
    final double cardWidth =
        MediaQuery.of(context).size.width / (isPortrait ? 1.6 : 3);

    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(right: _kPadding),
      child: ClipRRect(
        borderRadius: borderRadiusFromRadiusSize(_kBorderRadius),
        child: GestureDetector(
          onTap: () => onTap(context, data),
          child: Hero(
            tag: data,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                buildNetworkImage(data.image),
                Container(
                  margin: EdgeInsets.all(_kPadding / 2),
                  height: cardHeight / 2,
                  decoration: BoxDecoration(
                    borderRadius: borderRadiusFromRadiusSize(_kBorderRadius),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 16,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          data.title,
                          textAlign: TextAlign.start,
                          maxLines: isPortrait ? 5 : 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            buildCategoryTitle(
                              context,
                              data.category,
                            ),
                            Text(
                              DateFormat(
                                "dd MMMM yyyy",
                                ui.window.locale.languageCode,
                              ).format(data.pubDate),
                            ),
                          ],
                        )
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
