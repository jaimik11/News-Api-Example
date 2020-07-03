class photo {
  final int id;
  final String thumbnailUrl;
  final String url;

  photo({this.id, this.thumbnailUrl,this.url,});

  factory photo.fromJson(Map<String, dynamic> json) {
    return photo(
      id: json['id'] as int,
      thumbnailUrl: json['thumbnailUrl'] as String,
      url: json['url'] as String,
    );
  }
}
