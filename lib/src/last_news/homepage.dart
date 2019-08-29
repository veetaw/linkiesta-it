import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:linkiesta/src/common/utils.dart';
import 'package:provider/provider.dart';

import 'package:linkiesta/src/app.dart';
import 'package:linkiesta/src/feed/linkiesta.dart';
import 'package:linkiesta/src/feed/model/news_article.dart';
import 'package:linkiesta/src/last_news/last_news_card.dart';
import 'package:linkiesta/src/last_news/menu_icon.dart';
import 'package:linkiesta/src/last_news/news_card.dart';
import 'package:linkiesta/src/preview_dialog/preview.dart';

class HomePage extends StatelessWidget {
  final LinkiestaFeed feed = LinkiestaFeed();
  static const double _kPadding = 16;

  @override
  Widget build(context) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double cardHeight =
        MediaQuery.of(context).size.height / (isPortrait ? 2.5 : 1.5) +
            _kPadding;

    return NestedScrollView(
      headerSliverBuilder: (context, isScrolled) => <Widget>[
        SliverAppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: MenuIcon(),
          ),
          expandedHeight: 100,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(
              "Ultime notizie",
              style: TextStyle(
                color: Colors.black.withAlpha(200),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          actions: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Icon(Icons.search),
                color: Colors.black,
                onPressed: () => showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                  query: '',
                ),
              ),
            )
          ],
        ),
      ],
      body: Consumer<FeedChangeNotifier>(
        builder: (context, notifier, _) => FutureBuilder<List<NewsArticle>>(
          future: notifier.feedType == FeedType.last
              ? feed.combineAll()
              : feed.fetchNews(notifier.feedType),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return notifier.feedType == FeedType.last
                  ? _allNews(cardHeight, snapshot)
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 16),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => NewsCard(
                        data: snapshot.data[index],
                        onTap: onTap,
                        image: buildNetworkImage(snapshot.data[index].image),
                      ),
                    );
            }
            return Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  "Caricamento ...",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _allNews(
      double cardHeight, AsyncSnapshot<List<NewsArticle>> snapshot) {
    List last = snapshot.data.skip(5).toList();
    return ListView.builder(
      addAutomaticKeepAlives: true,
      padding: EdgeInsets.only(bottom: 16),
      itemCount: snapshot.data.length - 4,
      physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index == 0) {
          return SizedBox(
            height: cardHeight,
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              addAutomaticKeepAlives: true,
              padding: EdgeInsets.only(left: _kPadding, top: _kPadding),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) => LastNewsCard(
                data: snapshot.data[index],
                onTap: onTap,
                key: Key(snapshot.data[index].link),
              ),
            ),
          );
        }
        index -= 1;
        return NewsCard(
          data: last[index],
          onTap: onTap,
          image: buildNetworkImage(last[index].image),
        );
      },
    );
  }
}

onTap(BuildContext context, NewsArticle data) => Navigator.of(context).push(
      PageRouteBuilder(
        barrierDismissible: true,
        opaque: false,
        pageBuilder: (context, _, __) => Preview(
          data: data,
        ),
      ),
    );

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var results =
        Cache().articles.where((article) => !article.title.contains(query));
    return ListView(
      children: results.length == 0
          ? [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Text(
                  "Categorie",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ]
          : results
              .map(
                (article) => NewsCard(
                  data: article,
                  onTap: onTap,
                  image: buildNetworkImage(article.image),
                ),
              )
              .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Premi invio per cercare",
        style: TextStyle(
          fontSize: 24,
        ),
      ),
    );
  }
}
