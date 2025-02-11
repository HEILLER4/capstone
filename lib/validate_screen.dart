import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ValidateUserScreen extends StatefulWidget {
  @override
  _ValidateUserScreenState createState() => _ValidateUserScreenState();
}

class _ValidateUserScreenState extends State<ValidateUserScreen> {
  final TextEditingController studIdController = TextEditingController();
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("test_user");

  String result = "";

  void validateUser() {
    String studId = studIdController.text.trim();

    if (studId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter Student ID!")),
      );
      return;
    }

    dbRef.once().then((DatabaseEvent event) {
      bool userFound = false;
      String userEmail = "";
      String userSect = "";

      if (event.snapshot.exists) {
        Map<String, dynamic> users = Map<String, dynamic>.from(event.snapshot.value as Map);

        users.forEach((userId, userData) {
          if (userData["stud_Id"] == studId) {
            userFound = true;
            userEmail = userData["email"];
            userSect = userData["stud_Sect"];
          }
        });
      }

      setState(() {
        if (userFound) {
          result = "User found!\nEmail: $userEmail\nSection: $userSect";
        } else {
          result = "User not found!";
        }
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Validate User")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: studIdController, decoration: InputDecoration(labelText: "Enter Student ID")),
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
