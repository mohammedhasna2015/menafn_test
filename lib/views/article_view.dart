import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:menafn/model/tabel.dart';
import 'package:menafn/model/viewonstory.dart';
import 'package:menafn/screen/note_list.dart';
import 'package:menafn/utiles/database_helper.dart';
import 'package:menafn/screen/note_detail.dart';
import 'package:menafn/views/homepage.dart';
import 'package:share/share.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
//import 'package:firebase_admob/firebase_admob.dart';
import 'package:menafn/helper/widget.dart';
import 'package:menafn/model/tabel.dart';
import 'package:menafn/utiles/database_helper.dart';
import 'package:menafn/screen/note_detail.dart';
import 'package:menafn/helper/news.dart';
//import 'package:flutter_share/flutter_share.dart';

List<News> favorite = new List<News>();

class ArticleView extends StatefulWidget {
  final String postUrl;
  ArticleView({@required this.postUrl});
  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  DatabaseHelper databaseHelper = DatabaseHelper();
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
                color: Color(0xff29346B),
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

        // actions: <Widget>[
        // Container(
        //     padding: EdgeInsets.symmetric(horizontal: 16),
        //     child: IconButton(
        //         icon: Icon(Icons.share),
        //         onPressed: () {
        //           Share.share('nbdkfnbaonbklfdnbifrnronbarnblanbfn');
        //         }))
        // ],
        backgroundColor: Color(0xff88db52),
        elevation: 0.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WebView(
          initialUrl: widget.postUrl,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}

///=================================================================================

class StoryView extends StatefulWidget {
  final String imageStory,
      bodyStory,
      titleStory,
      storyDate,
      storytitle,
      newsLink;
  final String storyId;

  StoryView(
      {@required this.storyId,
      this.imageStory,
      this.bodyStory,
      this.titleStory,
      this.storyDate,
      this.storytitle,
      this.newsLink});

  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  List<ViewOneStory> oneStory = [];

  Future<List<ViewOneStory>> getNews(storyId) async {
    var data = await http
        .get("https://menafn.com/mobile/WebAPI/getnews/getstory/$storyId");
    print("https://menafn.com/mobile/WebAPI/getnews/getstory/$storyId");
    var jsonData = json.decode(data.body);
    print('**************');
    print(jsonData);
    print('**************');
    for (var u in jsonData) {
      ViewOneStory story = ViewOneStory(
          u["newsID"],
          u["newsTitle"],
          u["newsDate"],
          u["imagePath"],
          u["providerName"],
          u["newsLink"],
          u["providerLogo"],
          u["newsDisclaimer"],
          u["newsBody"],
          u["title"]);
      print('+++++++++++++++++++++++++++++++++++++++++++++++++++++++');
      debugPrint(story.toString());
      print('+++++++++++++++++++++++++++++++++++++++++');
      oneStory.add(story);
      print(storyId);
    }
    setState(() {
      _loading = false;
    });
    return oneStory;
  }

  var newslist;
  bool _loading = true;
  int cal = 1;

  Future<void> share(int id) async {
    CardItem(
      nLink: oneStory[id].newsLink ?? "",
    );
  }

  var helper;
  @override
  void initState() {
    helper = new DatabaseHelper();

    getNews(widget.storyId);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "MENA",
              style: TextStyle(
                fontSize: 30,
                color: Color(0xff29346B),
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
        actions: <Widget>[
          //  InkWell(
          //   onTap: () {
          //  News obj = new News(0, widget.storyDate, widget.titleStory,
          //   widget.imageStory, widget.storytitle, "", "");

          // favorite.add(obj);
          // if (cal!=2) {
          //   Note tablemodel = new Note(widget.storyId, widget.imageStory, widget.storytitle, widget.storyDate);
          //   //await helper.checkdublicate(id, tablemodel);
          //   //await helper.deleteNote(int.parse(this.id));
          //   await helper.insertNote(tablemodel);
          //   //await helper.deleteNote(int.parse(this.id));
          //   //await helper.insertNote(tablemodel);
          //
          //   if (helper.noteTable.contains(widget.storyId) == true) {
          //     await helper.deleteNote(int.parse(tablemodel.id));
          //     await helper.insertNote(tablemodel);
          //   }
          //
          //   //await helper.deleteNote(int.parse(tablemodel.id));
          //   // await helper.insertNote(tablemodel);
          //
          //   // Navigator.push(
          //   //     context,
          //   //     MaterialPageRoute(
          //   //         builder: (context) => NoteList()));
          // }
          // // helper.noteTable.contains(id) == true ;
          // },
          //  child: Container(
          // padding: EdgeInsets.symmetric(horizontal: 12),
          //child: (cal == 2)
          //   ? Icon(
          //      Icons.favorite,
          //       color: Colors.red,
          //      )
          //   : Icon(
          //       Icons.favorite_border,
          //        color: Colors.red,
          //      )),
          // ),
          InkWell(
            onTap: () async {
              //  FlutterShare.share(title: "kdffcidfjfif");
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Icon(
                  Icons.share,
                )),
          ),
        ],
        backgroundColor: Color(0xff88db52),
        elevation: 0.0,
      ),
      body: PageView.builder(
        itemCount: oneStory.length,
        itemBuilder: (BuildContext ctxt, int index) => CardItem(
          contant: oneStory[index].newsBody ?? "",
          head: oneStory[index].newsDate ?? "",
          picUrl: oneStory[index].imagePath ?? "",
          title: oneStory[index].newsTitle ?? "",
          id: oneStory[index].newsID.toString() ?? "",
          nLink: oneStory[index].newsLink ?? "",
        ),
      ),
    );
  }
}

///===================================================================
class CardItem extends StatelessWidget {
  final String picUrl, head, contant, title, id, imgUrl, nLink;
  CardItem(
      {this.picUrl,
      this.head,
      this.contant,
      this.title,
      this.id,
      this.imgUrl,
      this.nLink});
  DatabaseHelper helper = DatabaseHelper();
  int cal = 1;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 300.0,
        color: Colors.white,
        child: ListView(
          shrinkWrap: true,
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
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Html(
                  data: title,
                  padding: EdgeInsets.all(15),
                  defaultTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: 0,
                ), /////12
                // Text(
                Center(
                  child: Container(
                    child: Html(
                      data: head,
                      padding: EdgeInsets.only(left: 20, top: 0),
                    ),
                  ),
                ),
                //  SizedBox(
                //     height: 4,
                //   ),
                Html(
                  data: contant,
                  padding: EdgeInsets.only(left: 20, top: 30),
                  defaultTextStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  /* child: InkWell(
                    onTap: () async {
                      if (cal == 1) {
                        Note tablemodel = new Note(id, picUrl, title, contant);
                        //await helper.checkdublicate(id, tablemodel);
                        //await helper.deleteNote(int.parse(this.id));
                        await helper.insertNote(tablemodel);
                        //await helper.deleteNote(int.parse(this.id));
                        //await helper.insertNote(tablemodel);

                        if (helper.noteTable.contains(id) == true) {
                          await helper.deleteNote(int.parse(tablemodel.id));
                          await helper.insertNote(tablemodel);
                        }
                        cal++;
                        if (cal == 2) {
                          await helper.deleteNote(int.parse(tablemodel.id));
                          await helper.insertNote(tablemodel);
                        }
                        //await helper.deleteNote(int.parse(tablemodel.id));
                        // await helper.insertNote(tablemodel);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoteList()));
                      }
                    },
                     child: Row(
                      children: <Widget>[
                        Icon(
                          (helper.noteTable.contains(id) == true)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                          size: 30,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          "Favorite",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 33.33,
                        ),
                      ],
                    ),
                  ),*/
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _delete(BuildContext context, Note note) async {
    int result = await helper.deleteNote(int.parse(note.id));
    //var result= await context
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      //updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  // Future<void> share() async {
  //   await FlutterShare.share(
  //       title: 'the Article',
  //       text: contant,
  //       linkUrl: nLink,
  //       chooserTitle: title);
  // }

  void deleteme(context) async {
    int result = await helper.deleteNote(int.parse(this.id));
    //var s= await helper.deleteNote(id);
    //var result= await context
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      await helper.insertNote(null);
      //updateListView();
      //Note tablemodel = new Note(id,picUrl,title,contant);
      //await helper.checkdublicate(id, tablemodel);
      //await helper.insertNote(tablemodel);
      //int s =await helper.id.contains(this.id) ?? 0;
      // await helper.deleteNote(s);
      //if(this.title !=null){
      //await helper.deleteNote(int.parse(id));
      //await helper.deleteNote(int.parse(id));
      //await helper.insertNote(null);
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NoteList()));
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
