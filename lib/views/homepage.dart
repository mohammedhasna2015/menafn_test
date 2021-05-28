import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:intl/intl.dart';
import 'package:menafn/helper/data.dart';
import 'package:menafn/helper/widget.dart';
import 'package:menafn/main.dart';
import 'package:menafn/model/article.dart';
import 'package:menafn/model/categorymodel.dart';
import 'package:menafn/views/categorynews.dart';
import 'package:menafn/helper/news.dart';
import 'package:menafn/screen/note_list.dart';
import 'article_view.dart';
import 'drawer.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "HomePage",
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: PhotosListScreen(),
    );
  }
}

class PhotosListScreen extends StatefulWidget {

  PhotosListScreen({Key key}) : super(key: key);

  @override
  _PhotosListScreenState createState() => _PhotosListScreenState();

}

class _PhotosListScreenState extends State<PhotosListScreen> with SingleTickerProviderStateMixin {
  TabController tabContoller;
  GlobalKey<ScaffoldState> photoScreenKey = GlobalKey();

  static const adUnitID = "ca-app-pub-1786942026589567/7335010408";

  /*createNativeAd() {
    NativeAdmob nativeAdModAd = NativeAdmob(adUnitID: "ca-app-pub-1786942026589567/7335010408",
    controller: _controller,
    )
    return Container(
      width: double.infinity,
      height: 100,
      child: nativeAdModAd,
    );
  }*/
  createReawrdAdAndLoad() {
    RewardedVideoAd.instance.load(
        adUnitId:"ca-app-pub-1786942026589567/4152377284",
        targetingInfo: MobileAdTargetingInfo());
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      switch (event) {
        case RewardedVideoAdEvent.rewarded:

        ///
          break;
        default:
      }
      print(
          "*************createReawrdAdAndLoad $event*************");
    };
  }
  bool _hasMore;
  int _pageNumber;
  bool _error;
  bool _loading=false;
  final int _defaultPhotosPerPageCount = 10;
  List<News> _news;
  final int _nextPageThreshold = 5;
  List<CategorieModel> categories = List<CategorieModel>();
  List<Widget>tabs=[];
  List<String>tabsName=[];

  String firstTab="Home";
  @override
  void initState() {
    tabContoller = TabController(
        length: 2,
        vsync: this,
        initialIndex:0
    );
    categories = getCategories();
    super.initState();
    print("hhhhhhhhhhhhhhhhhhhhhh");


    createReawrdAdAndLoad();
    RewardedVideoAd.instance.show();


    _hasMore = true;
    _pageNumber = 1;
    _error = false;
    _news = [];
    tabs.add(tab("Home"));
    tabs.add(tab("Sports"));
    tabsName.add("Home");
    tabsName.add("sports");
    fetchPhotos(firstTab[0]);
  }

  void dispose() {
    //mybanner.dispose();
    super.dispose();
  }
  Widget tab (String tabName){
    return Tab(
      text: tabName,
    );
  }
  /* int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: favorite',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,  initialIndex: 0,
      child: Builder(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            bottom: TabBar(onTap: (index){

              fetchPhotos(firstTab[index]);
            },
              tabs: tabs,
              isScrollable: true,
              controller: tabContoller,
            ),
            centerTitle: true,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('images/logo.jpg',height: 30,)
              ],
            ),
            backgroundColor: Color(0xff88db52),
            elevation: 0.0,
          ),
          //  body: TabBarView(children: tabs.map((model) => getBody(Text(model.toString()).toString())).toList()
          body: TabBarView(controller: tabContoller,
            children: tabsName.map((getBody)).toList(),

          ),
        );
      }),
    );

    // return DefaultTabController(
    //   length: tabs.length,
    //   child: Scaffold(
    //     key: photoScreenKey,
    //     appBar: AppBar(
    //       bottom: TabBar(
    //         controller: tabContoller,
    //     onTap: (index){
    //             setState(() {
    //               fetchPhotos(firstTab[index]);
    //             });
    //           },
    //         tabs: tabs,
    //       ),
    //     ),
    //     body: TabBarView(
    //       controller: tabContoller,
    //       children: tabsName.map((getBody)).toList(),
    //     ),
    //   ),
    // );

  }

  Widget getBody( String tab) {
    if(_loading==false){
      return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CircularProgressIndicator(),
          ));
    }else{
      print("news_length"+_news.length.toString());
      if(_news.length!=0){
        return Container(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: _news.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {

                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StoryView(
                              storyId: _news.length!=0?_news[index].newsid.toString():"",
                            )));
                  },
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Stack(children: [
                          Image.network(
                            _news.length!=0?_news[index].picture:"",
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                          ),
                          Positioned(
                            bottom: 15,
                            left:-10,
                            child:  Padding(
                              padding: const EdgeInsets.all(16),
                              child: Container(
                                width: MediaQuery.of(context).size.width-10,
                                child: Text(_news.length!=0?_news[index].title:"",
                                    style: TextStyle(
                                        color:Colors.white,
                                        fontWeight: FontWeight.bold, fontSize: 28)),
                              ),
                            ),
                          ),
                        ],),
                      ],
                    ),
                  ),
                );
              }),

        );
      }

    }


  }


  Future<void> fetchPhotos(String nameTap) async {
    setState(() {
      _news = [];
      _loading=false;
    });
    _news = [];
    _news = [];
    _news = [];
    print(nameTap+"11111111111111111111");
      var xURL = "";
      print("nameTap   >>>>> " + nameTap);
      if (nameTap==tabsName[0])
      {
        print("contains   >>>>> " +nameTap);
        xURL = "https://menafn.com/mobile/WebAPI/getnews/getsection/MobileEN_Home-$_pageNumber";
      }
      else
      {
        xURL = "https://menafn.com/mobile/WebAPI/getnews/getsection/MobileEN_Sports-$_pageNumber";
      }
      print("url==========="+ xURL);
      final response = await http.get(xURL);


      //   "https://menafn.com/mobile/WebAPI/getnews/getsection/MobileEN_${tabs.map((model) => Text(model.toString()))}-$_pageNumber");
      List<News> fetchedPhotos = News.parseList(json.decode(response.body));
      print(response.statusCode);
      setState(() {
        _hasMore = fetchedPhotos.length == _defaultPhotosPerPageCount;

        _pageNumber = _pageNumber + 1;
        if(fetchedPhotos.isNotEmpty){
          setState(() {

            _news.addAll(fetchedPhotos);
            _loading = true;

          });
          print("news length "+_news.length.toString());
        }
      });


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


class CategoryCard extends StatelessWidget {
  final String imageAssetUrl, categoryName, categoryAPI;

  CategoryCard({this.imageAssetUrl, this.categoryName, this.categoryAPI});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNews(
                  newsCategory: categoryName.toLowerCase(),
                  newsAPI: categoryAPI.toString(),
                )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 14),
        padding: EdgeInsets.only(top: 5),
        child: Stack(
          children: <Widget>[

            Container(
              alignment: Alignment.center,
              height: 60,
              width: 120,
              /* decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black26),*/
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
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

