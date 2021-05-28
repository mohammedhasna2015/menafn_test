//id,picUrl,title,contant,head
class Note {

  String id;
  String picurl;
  String title;
  String contant;
  //String head;
 // String imgurl;
  Note(this.id, this.picurl,this.title, this.contant);
  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    //map['content'] = contant;
    map['picurl'] = picurl;
    //map['head'] = head;
   // map['imgurl'] = imgurl;
    return map;
  }
  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    //this.contant = map['content'];
    this.picurl = map['picurl'];
    //this.imgurl = map['imgurl'];
    //this.head = map['head'];
  }
}









