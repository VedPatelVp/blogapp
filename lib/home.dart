

import 'package:blogapp/services/crud.dart';
import 'package:blogapp/views/create_blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = new CrudMethods();
  Stream blogStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    crudMethods.getData().then((result){
      setState(() {
        blogStream = result;
      });
    });
  }

  Widget BlogsList(){
    return
       SingleChildScrollView(
        child:blogStream != null ? Column(
          children: <Widget>[
             StreamBuilder(
               stream: blogStream,
               builder: (context,snapshot){
               if(snapshot.data==null) return CircularProgressIndicator();
               return  ListView.builder(
                   padding: EdgeInsets.symmetric(horizontal: 16),
                   shrinkWrap:true,
                   physics: NeverScrollableScrollPhysics(),
                   itemCount: snapshot.data.documents.length,
                   itemBuilder: (context,i){
                     return BlogsTile(imgUrl: snapshot.data.documents[i].data["imgUrl"],
                         description: snapshot.data.documents[i].data["desc"],
                         authorname: snapshot.data.documents[i].data["authorName"],
                         title: snapshot.data.documents[i].data["title"]);
                   }
               );
             },
           )
          ],
        ):Container(alignment:Alignment.center,child: CircularProgressIndicator(),),
      );

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
      ),
      body: BlogsList(),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context){
                 return CreateBlog();
                }
              ));
            },
            child: Icon(Icons.add),
          )
        ],),
      ),
    );
  }
}

class BlogsTile extends StatelessWidget {

  String imgUrl,description,authorname,title;
  BlogsTile({@required this.imgUrl,@required this.description,@required this.authorname,@required this.title});


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 170,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(imageUrl: imgUrl,fit:BoxFit.cover,width: MediaQuery.of(context).size.width,),
          ),
          Container(height: 170,
            decoration: BoxDecoration(color: Colors.black45.withOpacity(0.3),
                borderRadius:BorderRadius.circular(6) ),),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(title,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                SizedBox(height: 4,),
                Text(description,style: TextStyle(fontSize: 17),),
                SizedBox(height: 4,),
                Text(authorname)
              ],
            ),
          )

        ],
      ),
    );
  }
}
