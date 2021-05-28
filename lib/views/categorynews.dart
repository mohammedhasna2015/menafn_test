import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:menafn/helper/data.dart';
import 'package:menafn/helper/news.dart';
import 'package:menafn/helper/widget.dart';
import 'package:menafn/model/viewonstory.dart';
import 'package:http/http.dart' as http;
import 'package:menafn/model/categorymodel.dart';
import 'article_view.dart';
import 'homepage.dart';

class CategoryNews extends StatefulWidget {
  final String newsCategory;
  final String newsAPI;
  CategoryNews({this.newsCategory, this.newsAPI});

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<News> newslist = new List<News>();
  bool _loading;
  bool _hasMore;
  int _pageNumber;
  bool _error;
  final int _defaultPhotosPerPageCount = 10;
  final int _nextPageThreshold = 5;
  List<CategorieModel> categories = List<CategorieModel>();

  @override
  void initState() {
    _hasMore = true;
    _pageNumber = 1;
    _error = false;
    _loading = true;
    categories = getCategories();
    fetchPhotos();

    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "MENA",
              style: TextStyle(
                fontSize: 30,
                color: Color(0xff29346b),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "FN",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
            }),
        actions: <Widget>[
          Opacity(
            opacity: 0,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.share,
                )),
          )
        ],
        backgroundColor: Color(0xff88db52),
        elevation: 0.0,
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: newslist.length + (_hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 70,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return CategoryCard(
                                 imageAssetUrl:
                                      categories[index].imageAssetUrl,
                                  categoryName: categories[index].categorieName,
                                  categoryAPI: categories[index].categoryAPI);
                            }),
                      );
                    if (index == newslist.length - _nextPageThreshold) {
                      fetchPhotos();
                    }
                    if (index == newslist.length) {
                      if (_error) {
                        return Center(
                            child: InkWell(
                          onTap: () {
                            setState(() {
                              _loading = true;
                              _error = false;
                              fetchPhotos();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                                "Error while loading photos, tap to try agin"),
                          ),
                        ));
                      } else {
                        return Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: CircularProgressIndicator(),
                        ));
                      }
                    }
                    final News photo = newslist[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StoryView(
                                      storyId: photo.newsid.toString(),
                                    )));
                      },
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Image.network(
                              photo.picture,
                              fit: BoxFit.fitWidth,
                              width: double.infinity,
                              height: 160,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(photo.title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
    );
  }

  Future<void> fetchPhotos() async {
    try {
      print('*******************************************');
      print(
          "https://menafn.com/mobile/WebAPI/getnews/getsection/${widget.newsAPI.toUpperCase()}-$_pageNumber");
      print('*******************************************');

      final response = await http.get(
          "https://menafn.com/mobile/WebAPI/getnews/getsection/${widget.newsAPI.toUpperCase()}-$_pageNumber");
      List<News> fetchedPhotos = News.parseList(json.decode(response.body));

      print(fetchedPhotos[0].title);
      setState(() {
        _hasMore = fetchedPhotos.length == _defaultPhotosPerPageCount;

        _pageNumber = _pageNumber + 1;
        newslist.addAll(fetchedPhotos);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }
}

class CardItem extends StatelessWidget {
  final String head, picUrl, contant, title;

  CardItem({this.picUrl, this.head, this.contant, this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 300.0,
        color: Colors.white,
        child: ListView(
          shrinkWrap: true,
          itemExtent: 1.0,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      picUrl,
                      height: 200,
                      width: 500,
                      // width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Html(
                  data: title,
                  defaultTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: 8,
                ), /////12
                // Text(
                Center(
                  child: Container(
                    child: Html(
                      data: contant,
                    ),
                  ),
                ),
                Html(
                  data: head,
                  defaultTextStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class News {
  final int newsid;
  final String newsdate;
  final String title;
  final String picture;
  final String company;
  final String link;
  final String description;

  News(this.newsid, this.newsdate, this.title, this.picture, this.company,
      this.link, this.description);

  factory News.fromJson(Map<String, dynamic> json) {
    return News(json["newsid"], json["newsdate"], json["title"],
        json["picture"], json["company"], json["link"], json["description"]);
  }
  static List<News> parseList(List<dynamic> list) {
    return list.map((i) => News.fromJson(i)).toList();
  }
}
