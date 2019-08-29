import 'package:dio/dio.dart';
import 'package:dio_cache/dio_cache.dart';
import 'package:webfeed/webfeed.dart';

import 'package:linkiesta/src/feed/model/news_article.dart';

enum FeedType { last, culture, economy, world, innovation, italy, politcs }

class LinkiestaFeed {
  final Cache cache = Cache();

  static const String baseUrl = "https://www.linkiesta.it/it/";

  static const Map _urlMap = {
    FeedType.last: "feed/latest/",
    FeedType.culture: "section/cultura/6/feed",
    FeedType.economy: "section/economia/1/feed",
    FeedType.world: "section/esteri/4/feed",
    FeedType.innovation: "section/innovazione/5/feed",
    FeedType.italy: "section/italia/3/feed",
    FeedType.politcs: "section/politica/2/feed"
  };

  static const Map categories = {
    FeedType.last: "Ultime notizie",
    FeedType.culture: "Cultura",
    FeedType.economy: "Economia",
    FeedType.world: "Esteri",
    FeedType.innovation: "Innovazione",
    FeedType.italy: "Italia",
    FeedType.politcs: "Politica"
  };

  Dio client;

  LinkiestaFeed()
      : client = Dio()
          ..interceptors.add(
            CacheInterceptor(
              options: CacheOptions(
                expiry: const Duration(hours: 1),
              ),
            ),
          );

  Future<String> _makeRequest(String endPoint) async {
    Response response = await client.get(
      baseUrl + endPoint,
      options: Options(
        headers: {"Accept": "application/xml"},
      ),
    );

    return response.data;
  }

  Future<List<NewsArticle>> fetchNews(FeedType feed) async {
    final String _rawData = await _makeRequest(_urlMap[feed]);

    AtomFeed rssFeed = parseData(_rawData);

    return rssFeed.items
        .map((a) => NewsArticle.fromAtom(a, categories[feed]))
        .toList();
  }

  AtomFeed parseData(String rawData) => AtomFeed.parse(
        rawData,
      );

  Future<List<NewsArticle>> combineAll() async {
    List<NewsArticle> result = [];
    for (FeedType url in _urlMap.keys.skip(1)) {
      result.addAll(await fetchNews(url));
    }

    result.sort((art, art1) => -art.pubDate.compareTo(art1.pubDate));
    cache.articles = result;
    return result;
  }
}

class Cache {
  static final Cache _singleton = Cache._();
  factory Cache() => _singleton;
  Cache._();

  List<NewsArticle> articles;
}
