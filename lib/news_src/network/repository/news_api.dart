

import 'package:api/news_src/model/news_model.dart';
import 'package:api/news_src/network/api_base_helper.dart';
import 'package:api/news_src/network/repository/I_news_api.dart';

class NewsRepository extends INewsAPi {
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  @override
  Future<List<Article>> getCategoryNews(String newsType) async {
    final response = await apiBaseHelper.get(newsType);
    return News.fromJson(response).articles;
  }

  @override
  Future<List<Article>> getTopHeadlines() async {
    final response = await apiBaseHelper.get("top-headlines");
    return News.fromJson(response).articles;
  }
}
