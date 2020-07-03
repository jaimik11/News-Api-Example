


List<CategoriesModel> loadCategories() {
  var categories = <CategoriesModel>[
    //adding all the categories of news in the list
    new CategoriesModel('images/top_news.png', "Top Headlines", "top_news"),
    new CategoriesModel('images/health_news.png', "Health", "health"),
    new CategoriesModel(
        'images/entertainment_news.png', "Entertainment", "entertainment"),
    new CategoriesModel('images/sports_news.png', "Sports", "sports"),
    new CategoriesModel('images/business_news.png', "Business", "business"),
    new CategoriesModel('images/tech_news.png', "Technology", "technology"),
    new CategoriesModel('images/science_news.png', "Science", "science"),
    new CategoriesModel('images/politics_news.png', "Politics", "politics"),

  ];
  return categories;
}


class CategoriesModel {
  String image;
  String title;
  String newsType;

  CategoriesModel(String image, String title, String newsType) {
    this.image = image;
    this.title = title;
    this.newsType = newsType;
  }



}
