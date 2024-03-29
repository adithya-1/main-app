import 'package:flutter/material.dart';
import 'package:not_bored/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfile extends StatefulWidget {
  static String tag = 'Edit';
  EditProfile({Key key, this.auth, this.profile}) : super(key: key);

  final BaseAuth auth;
  final Map profile;

  @override
  _EditProfileState createState() => _EditProfileState();
}

const PrimaryColor = const Color(0xFFf96327);

class _EditProfileState extends State<EditProfile> {
  final _formKey = new GlobalKey<FormState>();

  TextEditingController _name;
  TextEditingController _userid;
  TextEditingController _phone;
  TextEditingController _status;

  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = false;
    super.initState();
    _name = TextEditingController(text: widget.profile['name']);
    _userid = TextEditingController(text: widget.profile['userid']);
    _phone = TextEditingController(text: widget.profile['phone']);
    _status = TextEditingController(text: widget.profile['status']);
  }

  bool _updateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    _isLoading = false;
    return false;
  }

  void _updateAndSubmit() async {
    setState(() {
      _isLoading = true;
    });
    if (_updateAndSave()) {
      FirebaseUser user = await widget.auth.getCurrentUser();
      String userId = user.uid;
      try {
        Map _profile = {
          'name': _name.text,
          'userid': _userid.text,
          'phone': _phone.text,
          'status': _status.text,
        };

        widget.auth.updateProfile(_profile);
        print(' $userId is updated');
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Profile Updated"),
              content:
                  new Text("Your profile info has been successfully updated."),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Dismiss"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _showName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        controller: _name,
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'First Name',
            errorStyle: TextStyle(
              color: Colors.blue[900],
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrangeAccent)),
            icon: new Icon(
              Icons.person,
              color: Colors.black,
            )),
        validator: (value) {
          if (value.isEmpty) {
            setState(() {
              _isLoading = false;
            });
            return 'Name can\'t be empty';
          }
          return null;
        },
      ),
    );
  }

  Widget _showUserId() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        controller: _userid,
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'User ID',
            errorStyle: TextStyle(
              color: Colors.blue[900],
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrangeAccent)),
            icon: new Icon(
              Icons.verified_user,
              color: Colors.black,
            )),
        validator: (value) {
          if (value.isEmpty) {
            setState(() {
              _isLoading = false;
            });
            return 'Userid can\'t be empty';
          }
          return null;
        },
      ),
    );
  }

  Widget _showStatus() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        controller: _status,
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Status',
            errorStyle: TextStyle(
              color: Colors.blue[900],
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrangeAccent)),
            icon: new Icon(
              Icons.label_outline,
              color: Colors.black,
            )),
        validator: (value) {
          if (value.isEmpty) {
            setState(() {
              _isLoading = false;
            });
            return 'Status can\'t be empty';
          }
          return null;
        },
      ),
    );
  }

  Widget _showPhone() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        controller: _phone,
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Phone Number',
            errorStyle: TextStyle(
              color: Colors.blue[900],
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrangeAccent)),
            icon: new Icon(
              Icons.phone,
              color: Colors.black,
            )),
        validator: (value) {
          if (value.isEmpty) {
            setState(() {
              _isLoading = false;
            });
            return 'Phone number can\'t be empty';
          } else if (value.length != 10)
            return 'Mobile Number must be of 10 digit';
          return null;
        },
      ),
    );
  }

  Widget _showSaveButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: _updateAndSubmit,
        padding: EdgeInsets.all(12),
        color: const Color(0xFFf96327),
        child: Text('Save', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _showBody() {
    return new Scaffold(
        appBar: AppBar(
            backgroundColor: PrimaryColor,
            automaticallyImplyLeading: true,
            title: Text('Edit Profile')),
        body: Container(
            padding: EdgeInsets.all(16.0),
            child: new Form(
              key: _formKey,
              child: new ListView(
                shrinkWrap: true,
                children: <Widget>[
                  SizedBox(height: 50.0),
                  _showName(),
                  _showUserId(),
                  _showStatus(),
                  _showPhone(),
                  SizedBox(height: 50.0),
                  _showSaveButton(),
                ],
              ),
            )));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(
      children: <Widget>[
        _showBody(),
        _showCircularProgress(),
      ],
    ));
  }

  @override
  void dispose() {
    _name.dispose();
    _userid.dispose();
    _phone.dispose();
    _status.dispose();
    super.dispose();
  }
}
