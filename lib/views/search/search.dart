import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['All Pets', 'Dogs', 'Cats', 'Birds', 'Others'];
    final selectedCategory = 'All Pets';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Pet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {},
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
            Expanded(
              child: ListView(
                children: const [
                  PetCard(
                    name: 'Max',
                    breed: 'Golden Retriever',
                    age: '8 months',
                    gender: 'Male',
                    imageUrl: 'https://i.imgur.com/QwhZRyL.png',
                  ),
                  PetCard(
                    name: 'Luna',
                    breed: '<Maltest>',
                    age: '1.5 years',
                    gender: 'Female',
                    imageUrl: 'https://i.imgur.com/tGbaZCY.jpg',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PetCard extends StatelessWidget {
  final String name, breed, age, gender, imageUrl;

  const PetCard({
    super.key,
    required this.name,
    required this.breed,
    required this.age,
    required this.gender,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final genderColor = gender == 'Male' ? Colors.blue[100] : Colors.pink[100];
    final genderTextColor = gender == 'Male' ? Colors.blue : Colors.pink;

    return Card(
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
                child: Image.network(imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
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
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
