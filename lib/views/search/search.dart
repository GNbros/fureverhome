import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fureverhome/business_logic/pet_service.dart'; 
import 'package:fureverhome/models/pet_detail.dart';
import 'package:fureverhome/views/search/pet_details.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['All Pets', 'Dogs', 'Cats'];
    final selectedCategory = 'All Pets';

    final PetService petService = PetService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Pet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search pets...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Filter Chips
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category == selectedCategory;

                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {},
                    selectedColor: Colors.amber[100],
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Pet Cards
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
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white70,
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                    ),
                  ),
                )
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