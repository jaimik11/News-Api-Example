
import 'package:api/news_src/model/news_model.dart';

abstract class INewsAPi {
  Future<List<Article>> getCategoryNews(String newsType);

  Future<List<Article>> getTopHeadlines();
}
