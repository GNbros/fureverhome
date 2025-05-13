import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fureverhome/views/create_pet_listing.dart';
import 'package:fureverhome/business_logic/user_service.dart';
import 'package:fureverhome/business_logic/pet_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fureverhome/models/pet_detail.dart';
import 'package:fureverhome/views/search/pet_details.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? phone;
  String? address;
  String? userId;
  String? uid;
  Uint8List? picture;
  bool isLoading = false;
  List<PetDetail> userPets = []; 

  Future<void> fetchUserData() async {
    setState(() => isLoading = true);

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final user = await UserService().getUserByFirebaseUid(currentUser.uid);

      if (user != null) {
        setState(() {
          userId = user.id.toString();
          uid = user.firebaseUid;
          name = user.name;
          phone = user.phone;
          address = user.address;
          picture = user.profilePicture;
        });
        
        // Fetch pets associated with the user
        if (userId != null) {
          final pets = await PetService().getPetsCreatedByUser(int.parse(userId!));
          setState(() {
            userPets = pets; 
          });
        }
      }
    } catch (e) {
      debugPrint("Failed to load user: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
      ? const Center(child: CircularProgressIndicator())
      : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: picture != null
                        ? MemoryImage(picture!)
                        : const NetworkImage('https://i.imgur.com/QwhZRyL.png') as ImageProvider,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    name ?? 'Loading...',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Saved Pets & Create listing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionCard(
                    icon: Icons.add, 
                    title: "Add Pet", 
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CreatePetListingPage())
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // My Listings
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("My Listings", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 24),

              // Display the user's pets dynamically
              if (userPets.isEmpty)
                const Center(child: Text("You have no pets listed."))
              else
                ...userPets.map((pet) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PetDetailsPage(id: pet.id)),
                      );
                    },
                    child: _ListingCard(
                      image: pet.images.first.image,
                      name: pet.petName,
                      breed: pet.petBreed,
                      age: pet.age,
                    ),
                  );
                }).toList(),
            ],
          ),
        );
  }
}


class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: SizedBox(
          width: 160,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.purple),
              const SizedBox(height: 4),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}


class _ListingCard extends StatelessWidget {
  final Uint8List image;
  final String name;
  final String breed;
  final int age;

  const _ListingCard({
    required this.image,
    required this.name,
    required this.breed,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                image,
                width: 120,
                height: 120, // Increased height
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 120, // Match the image height
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(breed, style: const TextStyle(color: Colors.grey)),
                    Text('$age years', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

