import 'package:flutter/material.dart';
import 'package:fureverhome/views/main_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fureverhome/views/auth/login.dart';
import 'package:fureverhome/repositories/pet_repository.dart'; 
import 'package:fureverhome/models/pet_detail.dart';

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

    final PetRepository petRepository = PetRepository(); // Initialize PetRepository

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

          // Search and Filters
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search pets...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Chip(label: Text("Dogs")),
                    Chip(label: Text("Cats")),
                  ],
                ),
              ],
            ),
          ),

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
                  future: petRepository.getAllPets(), // Fetch all pets
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
                      children: pets.map((pet) {
                        return Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: pet.images.isNotEmpty
                                        ? Image.memory(
                                            pet.images.first.image, // Display the first image
                                            height: 120,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : const SizedBox(height: 120), // Placeholder
                                  ),
                                  const SizedBox(height: 8),
                                  Text(pet.petName), // Display pet name
                                  Text(pet.petBreed,
                                      style: const TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
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
