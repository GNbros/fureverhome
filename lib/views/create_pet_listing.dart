import 'package:flutter/material.dart';

class CreatePetListingPage extends StatelessWidget {
  const CreatePetListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Pet Listing"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image picker placeholders
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                3,
                (index) => Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Icon(Icons.camera_alt)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text("Add up to 5 photos"),

            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: "Pet Name"),
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: 'Dog',
                    items: const [
                      DropdownMenuItem(value: 'Dog', child: Text('Dog')),
                      DropdownMenuItem(value: 'Cat', child: Text('Cat')),
                    ],
                    onChanged: (val) {},
                    decoration: const InputDecoration(labelText: "Type"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    hint: const Text('Select breed'),
                    items: const [
                      DropdownMenuItem(value: 'Golden Retriever', child: Text('Golden Retriever')),
                      DropdownMenuItem(value: 'Poodle', child: Text('Poodle')),
                    ],
                    onChanged: (val) {},
                    decoration: const InputDecoration(labelText: "Breed"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Age",
                      hintText: "Years",
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: 'Male',
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                    ],
                    onChanged: (val) {},
                    decoration: const InputDecoration(labelText: "Gender"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text("Health Information", style: TextStyle(fontWeight: FontWeight.w600)),
            CheckboxListTile(title: const Text("Vaccinated"), value: false, onChanged: (_) {}),
            CheckboxListTile(title: const Text("Spayed/Neutered"), value: false, onChanged: (_) {}),
            CheckboxListTile(title: const Text("Kid Friendly"), value: false, onChanged: (_) {}),

            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: "Description",
                hintText: "Tell us about your pet...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: "Location",
                hintText: "Enter your location",
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD7B55A), // Golden color
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Create Listing"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
