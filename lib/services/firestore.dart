import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{

	// get collection of notes 
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

	// CREATE: add a new note
  Future<void> addNote(String note){
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

	// READ: get notes from database

	// UPDATE: update notes given a doc id

	// DELETE: delete notes given a doc id

}


/*
1) why use 'Future' datatype in creating notes
- "Return a Future that will complete when it's done"
- firestore operation is asynchronous — meaning, they don’t complete immediately and might take some time (like sending data over the internet).
- therefore you must use Future



*/