import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:menafn/views/article_view.dart';

Widget MyAppBar() {
  return AppBar(
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
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ],
    ),
    actions: [],
    centerTitle: true,
    backgroundColor: Color(0xff88db52),
    elevation: 0.0,
  );

  // actions: [
  //   Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 10),
  //   ),
  //   Icon(Icons.more_vert),
  // ],
}

class NewsTile extends StatelessWidget {
  final String imgUrl, title, desc, content, posturl;
  final int newsId;
  NewsTile(
      {this.imgUrl,
      this.desc,
      this.title,
      this.content,
      @required this.posturl,
      this.newsId});
  List<DropdownMenuItem<String>> listMunicipalities = [];
  String selected = null;

  void loadData() {
    listMunicipalities = [];
    listMunicipalities.add(new DropdownMenuItem(
      child: new Text('Port Moody'),
      value: 'Port Moody',
    ));
    listMunicipalities.add(new DropdownMenuItem(
      child: new Text('Vancouver Downtown'),
      value: 'Vancouver Downtown',
    ));
    listMunicipalities.add(new DropdownMenuItem(
      child: new Text('Coquitlam'),
      value: 'Coquitlam',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoryView(
                      storyId: newsId.toString(),
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 24),
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
        child: Container(
          child: Container(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(6),
                    bottomLeft: Radius.circular(6))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      imgUrl,
                      height: 150,

                      ///250
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    )),
                SizedBox(
                  height: 8,
                ), /////12
                // Text(
                Html(
                  data: title,
                  defaultTextStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
