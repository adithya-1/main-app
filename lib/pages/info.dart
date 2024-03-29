import 'package:flutter/material.dart';
import 'package:not_bored/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:not_bored/pages/splash.dart';
import 'package:not_bored/pages/edit_profile.dart';

class MyInfo extends StatefulWidget {
  MyInfo({Key key, this.auth, this.userId}) : super(key: key);

  final BaseAuth auth;
  final String userId;
  @override
  _MyInfoState createState() => _MyInfoState();
}

const PrimaryColor = const Color(0xFFf96327);

class _MyInfoState extends State<MyInfo> {
  File _image;

  Future uploadPic(BuildContext context) async {
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("pro_pics/" + widget.userId);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    final String url = (await taskSnapshot.ref.getDownloadURL());
    widget.auth.uploadProPic(url);
    setState(() {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Profile Picture Updated')));
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      uploadPic(context);
      print('Image Path $_image');
    });
  }

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
          return new Scaffold(
            appBar: AppBar(
                backgroundColor: PrimaryColor,
                automaticallyImplyLeading: true,
                title: Text('Profile Page'),
                actions: <Widget>[
                  FlatButton(
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => EditProfile(
                                    auth: widget.auth,
                                    profile: {
                                      'name': userDocument['name'],
                                      'userid': userDocument['userid'],
                                      'phone': userDocument['phone'],
                                      'status': userDocument['status'],
                                    },
                                  )));
                    },
                    child: Text("EDIT"),
                    shape: CircleBorder(
                        side: BorderSide(color: Colors.transparent)),
                  ),
                ],
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context, false),
                )),
            body: new Stack(
              children: <Widget>[
                ClipPath(
                  child: Container(color: Colors.black.withOpacity(0.8)),
                  clipper: GetClipper(),
                ),
                Positioned(
                    width: MediaQuery.of(context).size.width,
                    top: MediaQuery.of(context).size.height / 5,
                    child: Column(
                      children: <Widget>[
                        Container(
                            width: 150.0,
                            height: 150.0,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                image: DecorationImage(
                                    image:
                                        NetworkImage(userDocument['imageURL']),
                                    fit: BoxFit.cover),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(75.0)),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 7.0, color: Colors.black)
                                ])),
                        Container(
                          transform:
                              Matrix4.translationValues(50.0, -50.0, 0.0),
                          child: InkWell(
                            onTap: () => {getImage()},
                            borderRadius: BorderRadius.circular(70.0),
                            child: Container(
                              width: 55.0,
                              height: 55.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.deepOrange,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 35.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Text(
                          userDocument['name'],
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          userDocument['status'],
                          style: TextStyle(
                              fontSize: 17.0,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Montserrat'),
                        ),
                        SizedBox(height: 25.0),
                        Container(
                            height: 35.0,
                            width: 200.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.orangeAccent,
                              color: Colors.deepOrange,
                              elevation: 7.0,
                              child: GestureDetector(
                                onTap: () {},
                                child: Center(
                                  child: Text(
                                    userDocument['userid'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(height: 25.0),
                        Container(
                            height: 35.0,
                            width: 200.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.orangeAccent,
                              color: Colors.deepOrange,
                              elevation: 7.0,
                              child: GestureDetector(
                                onTap: () {},
                                child: Center(
                                  child: Text(
                                    userDocument['email'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(height: 25.0),
                        Container(
                            height: 35.0,
                            width: 200.0,
                            child: Align(
                                alignment: Alignment(-3.20, -1.40),
                                child: Material(
                                  borderRadius: BorderRadius.circular(30.0),
                                  shadowColor: Colors.orangeAccent[700],
                                  color: Colors.deepOrange,
                                  elevation: 7.0,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Center(
                                      child: Text(
                                        userDocument['phone'].toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ),
                                  ),
                                )))
                      ],
                    ))
              ],
            ),
          );
        });
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
