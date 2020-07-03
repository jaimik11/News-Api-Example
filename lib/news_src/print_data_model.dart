class NewsNews {
  String status;
  int totalResults;
  List<Article> articles;

  NewsNews({
    this.status,
    this.totalResults,
    this.articles,
  });

  factory NewsNews.fromJson(Map<String, dynamic> json) => NewsNews(
    status: json["status"],
    totalResults: json["totalResults"],
    articles: parsedata(json),
  );


  static List<Article> parsedata(datajson) {
    var list = datajson['articles'] as List;
    List<Article> articlelist = list.map((data) => Article.fromJson(data)).toList();
    return articlelist;

  }
}

class Article {
 final Source source;
 final String author;
 final String title;
 final String description;
 final String url;
 final String urlToImage;
 final DateTime publishedAt;
 final String content;

  Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
    source: Source.fromJson(json['source']),
    author: json['author'] == null ? null : json['author'],
    title:  json['title'],
    description: json['description'],
    url: json['url'],
    urlToImage: json['urlToImage'],
    publishedAt: DateTime.parse(json['publishedAt']),
    content: json['content'] == null ? null : json['content'],
  );



}

class Source {
  final  String id;
  final  String name;

  Source({
    this.id,
    this.name,
  });

  factory Source.fromJson(Map<String, dynamic> json) => Source(
    id: json['id'] == null ? null : json['id'],
    name: json['name'],
  );


}
