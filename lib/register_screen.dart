import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RegisterUserScreen extends StatefulWidget {
  @override
  _RegisterUserScreenState createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController studIdController = TextEditingController();
  final TextEditingController studSectController = TextEditingController();
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("test_user");

  void registerUser() {
    String email = emailController.text.trim();
    String studId = studIdController.text.trim();
    String studSect = studSectController.text.trim();

    if (email.isEmpty || studId.isEmpty || studSect.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    String userId = dbRef.push().key!; // Generate a unique key for the user
    dbRef.child(userId).set({
      "email": email,
      "stud_Id": studId,
      "stud_Sect": studSect,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User registered successfully!")),
      );
      emailController.clear();
      studIdController.clear();
      studSectController.clear();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register User")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: studIdController, decoration: InputDecoration(labelText: "Student ID")),
            TextField(controller: studSectController, decoration: InputDecoration(labelText: "Student Section")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerUser,
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
