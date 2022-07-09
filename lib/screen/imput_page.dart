import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class InputPage extends StatefulWidget {
  InputPage({Key? key}) : super(key: key);

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final formKey = GlobalKey<FormState>();
  bool _isloading = false;
  String name = "";

  String genre = "";

  int year = 0;
  String imageUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Input Page"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Column(
            children: [
              const SizedBox(height: 16,),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value){
                  if(value != null && value.isEmpty){
                    return "To'ldirilmagan";
                  }
                },
                onSaved: (value){
                  name = value!;
                },
              ),
              const SizedBox(height: 16,),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Genre",
                  border: OutlineInputBorder(),
                ),
                validator: (value){
                  if(value != null && value.isEmpty){
                    return "To'ldirilmagan";
                  }
                },
                onSaved: (value){
                  genre = value!;
                },
              ),
              const SizedBox(height: 16,),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Year",
                  border: OutlineInputBorder(),

                ),
                validator: (value){
                  if(value != null && value.isEmpty){
                    return "To'ldirilmagan";
                  }
                },
                onSaved: (value){
                  year = int.parse(value!);
                },
              ),

              TextButton(onPressed: (){
                _getImage();
              },
                  child: const Text("Upload Image", style: TextStyle(
                      fontSize: 19
                  ),)),
              const SizedBox(height: 24,),
              TextButton(onPressed: (){
              setState((){
                _addMovie(context);
              });
              },
                  child: const Text("Add", style: TextStyle(
                    fontSize: 19
                  ),)),
              // _isloading ? const Center(child:
              //   CircularProgressIndicator()
              //   )
              //     : Container(),
            ],
          ),
        ),
      ),
    );
  }

  void _addMovie(context){
    bool isValid = formKey.currentState!.validate();


    if(isValid){
      formKey.currentState!.save();
      _createMovie(context);
    }
  }

  void _createMovie(context)async{

   await  _saveToStorage();

     CollectionReference movies =
     FirebaseFirestore.instance.collection("movies");

     try{
       movies.doc(name.replaceAll(" ", "_")).set({
         'name' : name,
         'genre' : genre,
         'year' : year,
         'imageUrl' : _imageUrl,
       });
       Navigator.pop(context);
     }
     catch(e){
       print("ERROR_DATA ===> "  + e.toString());
     }
  }

  File _selectedImage = File("");
  String _imageUrl = "";
  Future _getImage() async{
    try{
      final _pickedFile = await ImagePicker().getImage(source : ImageSource.gallery);
      setState((){
        if(_pickedFile != null ){
          _selectedImage = File(_pickedFile.path);
        }
      });
    }
    on PlatformException catch(e){
      print("Failed to pick image + $e");
    }
  }

  Future<void> _saveToStorage() async {

    setState((){
      _isloading = true;
    });

    final storageRef =  FirebaseStorage.instance.ref();
    final uploadTask = await storageRef.child("banners")
        .child('$name.jpg').putFile(_selectedImage);

   _imageUrl = await uploadTask.ref.getDownloadURL() as String;


    setState((){
      _isloading = false;
    });
  }
}
