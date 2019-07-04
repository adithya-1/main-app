import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:not_bored/homepage.dart';
import 'package:not_bored/my_friends.dart';
import 'auth.dart';
import 'searchbar.dart';

class BottomNavigationBarProvider with ChangeNotifier {
  int _currentIndex = 0;

  get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

class CommonNavBar extends StatefulWidget {
  static String tag = 'navbar-page';
  CommonNavBar({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  @override
  _CommonNavBarState createState() => _CommonNavBarState();
}

class _CommonNavBarState extends State<CommonNavBar> {
  _signOutClose() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
    Navigator.of(context).pop();
  }

  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();

    _checkEmailVerification();
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resend link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: _signOutClose,
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: _signOutClose,
            ),
          ],
        );
      },
    );
  }

  var currentTab = [
    MyHomePage(),
    DataSearch(),
    MyFriendsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<BottomNavigationBarProvider>(context);

    return MaterialApp(
      home: ChangeNotifierProvider<BottomNavigationBarProvider>(
        child: Scaffold(
          body: currentTab[provider.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: provider.currentIndex,
            onTap: (index) {
              provider.currentIndex = index;
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                title: Text('Search'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                title: Text('Friends'),
              ),
            ],
            selectedItemColor: const Color(0xFFf96327),
          ),
        ),
        builder: (BuildContext context) => BottomNavigationBarProvider(),
      ),
    );
  }
}
