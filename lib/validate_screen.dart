import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ValidateUserScreen extends StatefulWidget {
  @override
  _ValidateUserScreenState createState() => _ValidateUserScreenState();
}

class _ValidateUserScreenState extends State<ValidateUserScreen> {
  final TextEditingController stud_idController = TextEditingController();

  // Change from FirebaseDatabase to FirebaseFirestore
  final CollectionReference dbRef = FirebaseFirestore.instance.collection("users");

  void validateUser() async {
    String studId = stud_idController.text.trim();

    if (studId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter Student ID!")),
      );
      return;
    }

    try {
      // Query Firestore for the student ID
      QuerySnapshot querySnapshot = await dbRef.where("stud_id", isEqualTo: studId).get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;

        setState(() {
          result = "User found!\nEmail: ${userData["email"]}\nSection: ${userData["section"]}";
        });
      } else {
        setState(() {
          result = "User not found!";
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    }
  }

  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Validate User")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: stud_idController, decoration: InputDecoration(labelText: "Enter Student ID")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: validateUser,
              child: Text("Validate"),
            ),
            SizedBox(height: 20),
            Text(result, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
