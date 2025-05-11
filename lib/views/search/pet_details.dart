import 'package:flutter/material.dart';

class PetDetailsPage extends StatelessWidget {
  final String name, breed, age, gender, imageUrl;

  const PetDetailsPage({
    super.key,
    required this.name,
    required this.breed,
    required this.age,
    required this.gender,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.favorite_border, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          // Pet Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(imageUrl, height: 240, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pet name and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text("Available", style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Quick Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoBox("Age", age),
                    _buildInfoBox("Gender", gender),
                  ],
                ),
                const SizedBox(height: 20),

                // About section
                Text("About $name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text(
                  "Max is a friendly and energetic $breed puppy looking for his forever home. He's great with children and other pets, fully vaccinated, and already knows basic commands.",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 20),

                // Additional Info
                _buildDetailTile(Icons.pets, "Breed", breed),
                _buildDetailTile(Icons.health_and_safety, "Healthy", "Vaccinated, Dewormed"),
                _buildDetailTile(Icons.location_on, "Location", "San Francisco, CA"),
                const SizedBox(height: 20),

                // Owner Info
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
                  ),
                  title: Text("Sarah Johnson"),
                  subtitle: Text("Pet Owner"),
                  trailing: Icon(Icons.verified, color: Colors.amber),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildDetailTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.amber),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.grey))),
        ],
      ),
    );
  }
}
