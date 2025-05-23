import 'package:cloud_firestore/cloud_firestore.dart';
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
  
 void openNoteBox({String? docID}){
  showDialog(context: context, builder: (context)=> AlertDialog(
    title: Text(docID == null ? 'Add Note' : 'Edit Note'), 
    content: TextField(
      controller: textController,
    ),
    actions:[
      //button to save
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: (){
              //add a new notes
              if(docID == null){
                firestoreService.addNote(textController.text);
              }
              // update an existing
              else{
                firestoreService.updateNote(docID, textController.text);
              }
              //clear the controller
              textController.clear();
              //close the box
              Navigator.pop(context);
            },
            child: Text(docID == null? 'Add' : 'Update'),
          ),
          ElevatedButton(
            onPressed: (){
              textController.clear();
              Navigator.pop(context);
            }, 
            child: Text('Cancel')
          ),
        ],
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
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot){
          //if we have data, get all the docs
          if(snapshot.hasData){
            List notesList = snapshot.data!.docs;

            //display as a list
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context,index){
                // get each individual doc
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                // get note from each doc
                Map<String, dynamic> data = 
                  document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                // display as a list tile, UI
                return ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      
                      IconButton(
                        onPressed: () => openNoteBox(docID: docID), 
                        icon: const Icon(Icons.settings)),

                      IconButton(
                        onPressed: ()=> firestoreService.deleteNote(docID),
                        icon: const Icon(Icons.delete),
                      )
                     
                    ],
                  ),
                );
              },
            );
          }

          // if there is no data return nothing
          else{
            return const Text("No notes");
          }
        },
      )
    );
  }
}