import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_simple_app/screen/imput_page.dart';
import 'package:flutter/material.dart';
import 'models/movie.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    final moviesRef = FirebaseFirestore.instance
        .collection('movies')
        .withConverter<Movie>(
      fromFirestore: (snapshots, _) => Movie.fromJson(snapshots.data()!),
      toFirestore: (movie, _) => movie.toJson(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Movie app"),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> InputPage()));
            },
         icon: Icon(Icons.add),
      ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Movie>>(
        stream: moviesRef.snapshots(),
        builder: (context, snapshot){
          final data = snapshot.requireData;
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()),);
          }
          if(snapshot.hasData){
            return ListView.separated(
                separatorBuilder: (BuildContext context, index){
                  return const Divider(height: 12,);
                },
                itemCount: data.size,
                itemBuilder: (BuildContext context, int index){
                  return Row(
                    children: [
                     movieItem(snapshot.data!.docs[index].data()),

                    ],
                  );
                });
          }
          return Container();
        },

      ),
    );
  }

  Widget movieItem(Movie movie){
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      child: Card(
        shape: RoundedRectangleBorder(
          // side: BorderSide(
          //   color: Colors.black38,
          // ),
          borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
        ),
        margin: EdgeInsets.symmetric(horizontal: 12 ,  vertical: 8),
        elevation: 24,
        color: Colors.black12,
        child: Row(
          children: [
           Container(
             height: 200,
             width: 200,
             child: FadeInImage(
               placeholder: AssetImage("assets/images/loading.png",),
                image:NetworkImage( "${movie.imageUrl}",) ,
              ),
           ),
            SizedBox(width: 18,),
            Column(
              children: [
                Text(
                movie.name ?? "",
                  style:const TextStyle(fontSize: 21),
                ),
                Text(
                  movie.genre ?? "",
                  style:const TextStyle(fontSize: 18),
                ),
                Text(
                  movie.year.toString() ?? "",
                  style:const TextStyle(fontSize: 16),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
