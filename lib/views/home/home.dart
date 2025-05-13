import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fureverhome/views/main_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fureverhome/views/auth/login.dart';
import 'package:fureverhome/business_logic/pet_service.dart'; 
import 'package:fureverhome/models/pet_detail.dart';
import 'package:fureverhome/views/search/pet_details.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Redirect to Login if not authenticated
    if (user == null) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final PetService petService = PetService(); // Initialize PetRepository

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section
          Container(
            color: const Color(0xFFF3E4B2),
            width: double.infinity,
            height: 250,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Find Your Perfect Companion",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text("Give a loving home to a pet in need"),
                const SizedBox(height: 16),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(selectedIndex: 1),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text("Start Adoption Journey"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Featured Pets
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Featured Pets",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),
                
                // FutureBuilder to load pets from the repository
                FutureBuilder<List<PetDetail>>(
                  future: petService.getAllPets(), // Fetch all pets
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No pets found.'));
                    }

                    final pets = snapshot.data!;

                    return Column(
                      children: pets.map<Widget>((pet) {
                        return PetCard(
                          name: pet.petName,
                          breed: pet.petBreed,
                          age: pet.age.toString() + ' year(s)',
                          gender: pet.gender.toString(),
                          image: pet.images.first.image,
                          id: pet.id,
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}


class PetCard extends StatelessWidget {
  final String name, breed, age, gender;
  final int id;
  final Uint8List image;

  const PetCard({
    super.key,
    required this.name,
    required this.breed,
    required this.age,
    required this.gender,
    required this.image,
    required this.id
  });

  @override
  Widget build(BuildContext context) {
    final genderColor = gender == 'Male' ? Colors.blue[100] : Colors.pink[100];
    final genderTextColor = gender == 'Male' ? Colors.blue : Colors.pink;

    return 
    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetDetailsPage(
              id: id
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image & Favorite icon
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.memory(image, height: 180, width: double.infinity, fit: BoxFit.cover),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Gender
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: genderColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(gender, style: TextStyle(color: genderTextColor, fontSize: 12)),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(breed, style: const TextStyle(color: Colors.grey)),

                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(age, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(width: 16),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
