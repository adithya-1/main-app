import 'package:flutter/material.dart';
import 'package:not_bored/services/auth.dart';
import 'package:not_bored/pages/splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Edit extends StatefulWidget {
  static String tag = 'Edit';
  Edit({Key key, this.auth, this.userId}) : super(key: key);

   final BaseAuth auth;
  final String userId;

  @override
  _EditState createState() => _EditState();
}

const PrimaryColor = const Color(0xFFf96327);

class _EditState extends State<Edit> {
   final _formKey = new GlobalKey<FormState>();

  
  TextEditingController _fname;
   TextEditingController _lname;
   TextEditingController _userid;
  TextEditingController _phone;
  TextEditingController _status;

    bool _isLoading;

@override

 Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Splash();
          }
          var userDocument = snapshot.data;

     void initState() {
   _isLoading = false;
    super.initState();
    _fname = TextEditingController(text: userDocument['fname']);
     _lname = TextEditingController(text: userDocument['lname']);
    _status = TextEditingController(text: userDocument['status']);
    _userid = TextEditingController(text: userDocument['userid']);
    _phone = TextEditingController(text: userDocument['phone']);
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
      String userId = "";
      try {
        Map _profile = {
          'fname': _fname.text,
          'lname': _lname.text,
          'userid': _userid.text,
          'phone': _phone.text,
          'status': _status.text,  
        };
        userId = await widget.auth.useriden(_profile);
         print(' $userId is updated');
         setState(() {
          _isLoading = false;
        });
         } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          
        });
      }
    }
  }



   Widget _showFirstName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        controller: _fname,
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            //hintText: 'First Name',
            errorStyle: TextStyle(
              color: Colors.blue[900],
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70)),
            icon: new Icon(
              Icons.mail,
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

   Widget _showLastName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        controller: _lname,
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
           // hintText: 'Last Name',
            errorStyle: TextStyle(
              color: Colors.blue[900],
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70)),
            icon: new Icon(
              Icons.mail,
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
          //  hintText: 'User ID',
            errorStyle: TextStyle(
              color: Colors.blue[900],
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70)),
            icon: new Icon(
              Icons.mail,
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

   Widget _showstatus() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        controller: _status,
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            //hintText: 'First Name',
            errorStyle: TextStyle(
              color: Colors.blue[900],
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70)),
            icon: new Icon(
              Icons.mail,
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

   Widget _showPhone() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        controller: _phone,
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        decoration: new InputDecoration(
          //  hintText: 'Phone Number',
            errorStyle: TextStyle(
              color: Colors.blue[900],
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70)),
            icon: new Icon(
              Icons.mail,
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
        color: Colors.white,
        child:
            Text('Save', style: TextStyle(color: const Color(0xFFf96327))),
      ),
    );
  }

 Widget _showBody() {
    return new Scaffold(
        backgroundColor: const Color(0xFFf96327),
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
                  _showFirstName(),
                  _showLastName(),
                  _showUserId(),
                  _showstatus(),
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

  return new Scaffold(
        body: Stack(
      children: <Widget>[
        _showBody(),
        _showCircularProgress(),
      ],
    ));


});
 }
 

}