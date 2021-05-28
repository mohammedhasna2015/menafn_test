import 'package:http/http.dart' as http;
import 'package:menafn/model/article.dart';
import 'dart:convert';

class News {
  String Lang = 'EN';
  List<Article> news = [];
  Future<List<Article>> getNews() async {
    ///menafn.com/mobile/WebAPI/getnews/getsection/MobileEN_Home
    String url = Lang == 'AR'
        ? "https://menafn.com/mobile/WebAPI/getnews/getsection/MobileEN_Entertainment"
        : "https://menafn.com/mobile/WebAPI/getnews/getsection/MobileEN_Home";
    var data = await http.get(url);
    //var data=await  http.get("https://menafn.com/mobile/WebAPI/getnews/getsection/MobileEN_Home");
    var jsonData = json.decode(data.body);
    print(jsonData);
    for (var u in jsonData) {
      Article story = Article(u["newsid"], u["newsdate"], u["title"],
          u["picture"], u["company"], u["link"], u["description"]);
      news.add(story);
    }
    return news;
  }
}

class NewsForCategorie {
  List<Article> news = [];
  Future<List<Article>> getNewsForCategory(String name) async {
    var data = await http
        .get("https://menafn.com/mobile/WebAPI/getnews/getsection/${name}");
    var jsonData = json.decode(data.body);
    for (var u in jsonData) {
      Article story = Article(u["newsid"], u["newsdate"], u["title"],
          u["picture"], u["company"], u["link"], u["description"]);
      news.add(story);
    }
    return news;
  }
}
