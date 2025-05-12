import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fureverhome/views/create_pet_listing.dart';
import 'package:fureverhome/business_logic/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
          picture = user.profilePicture; // Should be stored as base64 or bytes
        });
        debugPrint("User data loaded: $picture");
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
              _ActionCard(icon: Icons.favorite, title: "Saved Pets"),
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
              Text("View All", style: TextStyle(color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 24),
          _ListingCard(
            image: 'https://i.imgur.com/QwhZRyL.png',
            name: 'Max',
            breed: 'Golden Retriever',
            age: '8 months',
            status: 'Active',
            requestCount: 3,
          ),
          _ListingCard(
            image: 'https://i.imgur.com/tGbaZCY.jpg',
            name: 'Luna',
            breed: 'Maltest',
            age: '1.5 years',
            status: 'Active',
            requestCount: 1,
          ),
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
  final String image;
  final String name;
  final String breed;
  final String age;
  final String status;
  final int requestCount;

  const _ListingCard({
    required this.image,
    required this.name,
    required this.breed,
    required this.age,
    required this.status,
    required this.requestCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            image,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 60, color: Colors.grey),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                width: 60,
                height: 60,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              );
            },
          ),
        ),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$breed '),
            Text('• $age'),
            Text('$requestCount requests', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Chip(label: Text(status), backgroundColor: Colors.green.shade100),
          ],
        ),
      ),
    );
  }
}
