import 'package:flutter/material.dart';
import 'package:p3_simple_crud_firebase/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //firestore 
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController textController = TextEditingController();
  
 void openNoteBox(){
  showDialog(context: context, builder: (context)=> AlertDialog(
    content: TextField(
      controller: textController,
    ),
    actions:[
      //button to save
      ElevatedButton(
        onPressed: (){
          //add a new notes
          firestoreService.addNote(textController.text);

          //clear the controller
          textController.clear();

          //close the box
          Navigator.pop(context);
        },
        child: Text("Add")
      )
    ]
  ));

 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes")),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),  
      ),
    );
  }
}