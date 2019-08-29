import 'package:webfeed/webfeed.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' show Document;

class NewsArticle {
  String title;
  String description;
  String link;
  String image;
  String authors;
  DateTime pubDate;
  String category;

  NewsArticle(
    this.title,
    this.description,
    this.link,
    this.image,
    this.authors,
    this.pubDate,
    this.category,
  );

  NewsArticle.fromAtom(AtomItem atom, this.category) {
    Document document = parse(atom.content);

    title = atom.title;
    link = atom.id;
    authors = atom.authors.map((author) => author.name).join(", ");
    pubDate = DateTime.parse(atom.published);
    image = document.getElementsByTagName("img").first.attributes["src"];
    description = document.getElementsByTagName("p").first.text;
  }
}
