import 'dart:async';
import 'package:flutter/material.dart';
import 'package:menafn/helper/widget.dart';
import 'package:menafn/model/tabel.dart';
import 'package:menafn/utiles/database_helper.dart';
import 'package:menafn/screen/note_detail.dart';
import 'package:menafn/views/article_view.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

List<Note> noteList = new List<Note>();

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  int count = 0;
  bool louding = true;
  initState() {
    updateListView();
    setState(() {});
    print('xxxxxxxxxxxxxxxxxx');
    //print(noteList.length);
    print('xxxxxxxxxxxxxxxxxx');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    updateListView();
    return Scaffold(
        appBar: AppBar(
          title: Text('favorite'),
          actions: [],
        ),
        body: (louding)
            ? Container(
                child: Center(child: Text("No Favorite")),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: favorite.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 200,
                      child: Center(
                          child: Text(favorite[index].title ?? "NO FAVORITE")));
                },
              ));
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(int.parse(note.id));
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) async {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      await noteListFuture.then((noteListx) {
        setState(() {
          noteList = noteListx;
          louding = false;
        });
        print(noteList.length.toString() + "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      });
      print('***************************');
      setState(() {});
      print(noteList.toString());
    });
  }
}
