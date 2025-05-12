import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fureverhome/business_logic/user_service.dart';
import 'package:fureverhome/models/user_detail.dart';
import 'package:fureverhome/views/main_base.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserDetailsPage extends StatefulWidget {
  final String email;
  final String password;

  UserDetailsPage({required this.email, required this.password});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  File? _profileImage;
  
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery); // Updated method
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _submitDetails() async {
    final name = _nameController.text;
    final phone = _phoneController.text;
    final address = _addressController.text;
    final firebaseUid = FirebaseAuth.instance.currentUser?.uid;

    if (name.isNotEmpty && phone.isNotEmpty && address.isNotEmpty && firebaseUid != null) {
      final userService = UserService();
      final existingUser = await userService.getUserByFirebaseUid(firebaseUid);

      if (existingUser != null) {
        final updatedUser = UserDetail(
          id: existingUser.id,
          firebaseUid: firebaseUid,
          name: name,
          phone: phone,
          address: address,
        );

        await userService.updateUserDetails(updatedUser);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found in local DB.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields!')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Complete Your Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Field
              Text('Name', style: TextStyle(fontSize: 16)),
              TextField(controller: _nameController),
              SizedBox(height: 16),

              // Phone Field
              Text('Phone', style: TextStyle(fontSize: 16)),
              TextField(controller: _phoneController),
              SizedBox(height: 16),

              // Address Field
              Text('Address', style: TextStyle(fontSize: 16)),
              TextField(controller: _addressController),
              SizedBox(height: 16),

              // Profile Image Picker
              Text('Profile Picture', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : null,
                  child: _profileImage == null
                      ? Icon(Icons.camera_alt, size: 30, color: Colors.grey)
                      : null,
                ),
              ),
              SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _submitDetails,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), backgroundColor: Colors.amber.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
