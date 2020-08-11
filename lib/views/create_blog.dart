import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:blogapp/services/crud.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {

  String authorName, title, desc;
  bool _isLoading = false;
  File _image;
  final picker = ImagePicker();
  CrudMethods crudMethods = new CrudMethods();

  uploadBlog() async{
    if(_image!=null){
      setState(() {
        _isLoading=true;
      });
      ///firebase storage
      StorageReference firebaseStorageref = FirebaseStorage.instance.ref().child("blogImages")
          .child("${randomAlphaNumeric(9)}.jpg");
      final StorageUploadTask task = firebaseStorageref.putFile(_image);
      var dowloadUrl = await (await task.onComplete).ref.getDownloadURL();
      print("this is url $dowloadUrl");

      Map<String,String> blogMap = {
        "imgUrl": dowloadUrl,
        "authorName":authorName,
        "title":title,
        "desc":desc,
      };
      crudMethods.addData(blogMap).then((result) => Navigator.pop(context));
    }else{

    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Flutter",style: TextStyle(fontSize: 22),),
            Text("Blog",style: TextStyle(fontSize: 22,color: Colors.blue),)
          ],),
        backgroundColor: Colors.transparent,
        elevation: 10.0,
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              uploadBlog();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.file_upload)),
          ),
        ],
      ),
      body: _isLoading ?Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ) :Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10,
            ),
            GestureDetector(
              onTap: (){
                getImage();
              },
              child: _image != null ? Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 170,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(_image,fit: BoxFit.cover,)),
              ) :Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 170,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                width: MediaQuery.of(context).size.width,
                child: Icon(Icons.add_a_photo,color: Colors.black45,),
              ),
            ),
            SizedBox(height: 8,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(hintText: "Author Name",),
                    onChanged: (value){
                      authorName=value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Title",),
                    onChanged: (value){
                      title=value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Description",),
                    onChanged: (value){
                      desc=value;
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
