class Page {
  final int page;
  final int per_page;
  final int total;
  final int total_pages;
  final Auther auther;
  final List<Data> data;

  Page(
      {this.page,
      this.per_page,
      this.total,
      this.total_pages,
      this.auther,
      this.data});

  factory Page.fromJson(Map<String, dynamic> json) {
    return Page(
        page: json['page'],
        per_page: json['per_page'],
        total: json['total'],
        total_pages: json['total_pages'],
        auther: Auther.fromJson(json['author']),
      data: parsedata(json),
    );
  }

  static List<Data> parsedata(datajson) {
    var list = datajson['data'] as List;

    List<Data> datalist = list.map((data) => Data.fromJson(data)).toList();
    return datalist;

  }


}

class Auther {
  final String first_name;
  final String last_name;

  Auther({this.first_name, this.last_name});

  factory Auther.fromJson(Map<String, dynamic> json) {
    return Auther(
      first_name: json['first_name'],
      last_name: json['last_name'],
    );
  }
}



class Data {
  final int id;
  final String first_name;
  final String last_name;
  final String avatar;
  final List<Images> images;

  Data({this.id , this.first_name, this.last_name, this.avatar,this.images});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        id: json['id'],
        first_name: json['first_name'],
        last_name: json['last_name'],
        avatar: json['avatar'],
      images: parseimages(json)
    );

  }

  static List<Images> parseimages(imagesJson) {
    var list = imagesJson['images'] as List;

    List<Images> imagesList =
    list.map((data) => Images.fromJson(data)).toList();
    return imagesList;
  }
}

class Images {
  final int id;
  final String imageName;

  Images({this.id, this.imageName});

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      id: json['id'],
      imageName: json['imageName'],
    );
  }
}

