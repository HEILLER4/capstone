import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proto_run/utils/qr_generator.dart'; // Import QR generator

class RegisterUserScreen extends StatefulWidget {
  @override
  _RegisterUserScreenState createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final TextEditingController nameController = TextEditingController(); // Added Name Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController stud_idController = TextEditingController();
  final TextEditingController sectionController = TextEditingController(); // Changed sect -> section

  void registerUser() async {
    String name = nameController.text.trim(); // New name input
    String email = emailController.text.trim();
    String studId = stud_idController.text.trim();
    String section = sectionController.text.trim(); // Updated section field

    if (name.isEmpty || email.isEmpty || studId.isEmpty || section.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    String userId = FirebaseFirestore.instance.collection("users").doc().id; // Generate Firestore document ID

    // ✅ Store data in Firestore
    await FirebaseFirestore.instance.collection("users").doc(userId).set({
      "name": name, // New field
      "email": email,
      "stud_Id": studId,
      "section": section, // Updated field name
    }).then((_) async {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User registered successfully!")),
      );

      // ✅ Save QR Code Image to Device
      await saveQRCode(studId);

      nameController.clear();
      emailController.clear();
      stud_idController.clear();
      sectionController.clear();
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
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Full Name")), // Added Name
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: stud_idController, decoration: InputDecoration(labelText: "Student ID")),
            TextField(controller: sectionController, decoration: InputDecoration(labelText: "Section")), // Updated Section
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
