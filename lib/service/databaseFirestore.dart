import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  Future addTask(Map<String, dynamic> taskInformation,String id)async {
    try {
      return await FirebaseFirestore.instance.collection("Task").doc(id).set(
          taskInformation);
    } catch (e) {
      print("Error adding task: $e");
      throw e;
    }
  }

  Future deleteTask(String id)async{
    try{
      DocumentReference docRef = FirebaseFirestore.instance.collection("Task").doc(id);
      await docRef.delete();
    }catch(e){
   print('error $e');
    }

  }

  Future<void> updateTask(String id, Map<String, dynamic> updatedTaskInformation) async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance.collection("Task")
          .doc(id);
      await docRef.update(updatedTaskInformation);
      print("Task with ID $id updated successfully.");
    } catch (e) {
      print("Error updating task with ID $id: $e");
    }
  }}