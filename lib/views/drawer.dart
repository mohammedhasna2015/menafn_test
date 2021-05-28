import 'package:flutter/material.dart';
import 'package:menafn/views/homepage.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text(
              "HomePage",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontStyle: FontStyle.normal),
            ),
            leading: Icon(
              Icons.home,
              color: Colors.blue,
              size: 25,
            ),

            //trailing: Icon(Icons.hot_tub),
            //subtitle: Text("Wawa"),
            // isThreeLine: true,
            dense: true,
            // onLongPress: (){
            //print("longpress");
            //},
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          ListTile(
            title: Text("Categories",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontStyle: FontStyle.normal)),
            leading: Icon(
              Icons.category,
              color: Colors.blue,
              size: 25,
            ),
            onTap: () {
              Navigator.of(context).pushNamed('categoriesnews');
            },
          ),
          Divider(
            color: Colors.blue,
            height: 10,
            thickness: 2,
          ),
          ListTile(
            title: Text("About Application",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontStyle: FontStyle.normal)),
            leading: Icon(
              Icons.info,
              color: Colors.blue,
              size: 25,
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text("Setting",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontStyle: FontStyle.normal)),
            leading: Icon(
              Icons.settings,
              color: Colors.blue,
              size: 25,
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text("Logout",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontStyle: FontStyle.normal)),
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.blue,
              size: 25,
            ),
            onTap: () {
              Navigator.of(context).pushNamed("login");
            },
          ),
        ],
      ),
    );
  }
}
