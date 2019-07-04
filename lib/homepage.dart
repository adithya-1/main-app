import 'package:flutter/material.dart';

//PAGES
import 'about.dart';
import 'info.dart';
import 'searchbar.dart';
import 'auth.dart';
import 'my_friends.dart';

class MyHomePage extends StatefulWidget {
  static String tag = 'home-page';
  MyHomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: const Color(0xFFf96327),
        title: Text("Not Bored"),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          backgroundColor: const Color(0xFFf96327),
        ),
        child: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text('Adithya'),
                accountEmail: Text('adithyaaravi10@gmail.com'),
                decoration: BoxDecoration(color: const Color(0xFFf96327)),
                currentAccountPicture: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => UserInfo()));
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://yt3.ggpht.com/-hvABjgr3fn8/AAAAAAAAAAI/AAAAAAAAFLI/0LG1v5zQMKw/s88-mo-c-c0xffffffff-rj-k-no/photo.jpg'),
                  ),
                ),
                onDetailsPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => UserInfo()));
                },
              ),
              ListTile(
                title: Text('About'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => AboutPage()));
                },
              ),
              ListTile(
                title: Text('Log Out'),
                onTap: _signOut,
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 140.0,
        width: 140.0,
        child: FittedBox(
          child: FloatingActionButton(
            child: new Icon(
              Icons.sentiment_dissatisfied,
              size: 50.0,
              color: Colors.white54,
            ),
            backgroundColor: const Color(0xFFf96327),
            foregroundColor: Colors.white54,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}


