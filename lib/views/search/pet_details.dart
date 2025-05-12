import 'package:flutter/material.dart';
import 'package:fureverhome/business_logic/pet_service.dart';
import 'package:fureverhome/business_logic/user_service.dart';
import 'package:fureverhome/models/pet_detail.dart';
import 'package:fureverhome/models/user_detail.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';


class PetDetailsPage extends StatelessWidget {
  final int id;

  const PetDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final PetService petService = PetService();
    final UserService userService = UserService();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<PetDetail?>(
        future: petService.getPetDetails(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final pet = snapshot.data;
          if (pet == null) {
            return const Center(child: Text("Pet not found."));
          }

          return ListView(
            children: [
              // Pet Image
              if (pet.images.isNotEmpty)
                SizedBox(
                  height: 240,
                  child: PhotoViewGallery.builder(
                    itemCount: pet.images.length,
                    builder: (context, index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: MemoryImage(pet.images[index].image),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered,
                      );
                    },
                    scrollPhysics: BouncingScrollPhysics(),
                    backgroundDecoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    pageController: PageController(),
                  ),
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
                        Text(pet.petName,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text("Available",
                              style: TextStyle(
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Quick Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoBox("${pet.age}", "Age"),
                        _buildInfoBox(pet.gender, "Gender"),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // About section
                    Text("About ${pet.petName}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      pet.description,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 20),

                    // Additional Info
                    _buildDetailTile(Icons.pets, "Breed", pet.petBreed),
                    _buildDetailTile(Icons.pets, "Type", pet.petType),
                    _buildDetailTile(Icons.health_and_safety, "Health",
                        _healthStatus(pet)),
                    _buildDetailTile(Icons.location_on, "Location", pet.location),

                    const SizedBox(height: 20),


                    // Owner Info
                    FutureBuilder<UserDetail?>(
                      future: userService.getUserDetails(pet.userId),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (userSnapshot.hasError) {
                          return const Text("Failed to load owner info.");
                        }
                        final user = userSnapshot.data;
                        if (user == null) {
                          return const Text("Owner not found.");
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: user.profilePicture != null
                               ? CircleAvatar(
                                backgroundImage: MemoryImage(user.profilePicture!),
                                )
                                : const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                              title: Text(user.name),
                              subtitle: const Text("Pet Owner"),
                              trailing: const Icon(Icons.verified, color: Colors.amber),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.phone, color: Colors.green, size: 20),
                                const SizedBox(width: 8),
                                Text(user.phone, style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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
              style: const TextStyle(fontSize: 13),
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

  String _healthStatus(PetDetail pet) {
    final List<String> status = [];
    if (pet.isVaccinated) status.add("Vaccinated");
    if (pet.isSpayed) status.add("Spayed/Neutered");
    if (status.isEmpty) return "Unknown";
    return status.join(", ");
  }
}
