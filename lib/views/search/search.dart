import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fureverhome/business_logic/pet_service.dart'; 
import 'package:fureverhome/models/pet_detail.dart';
import 'package:fureverhome/models/breed.dart';
import 'package:fureverhome/models/pet_type.dart';
import 'package:fureverhome/views/search/pet_details.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final PetService petService = PetService();
  final TextEditingController _searchController = TextEditingController();
  List<PetType> _types = [];
  List<Breed> _breeds = [];

  String? name;
  String? selectedGender;
  bool? isVaccinated;
  bool? isSpayed;
  bool? isKidFriendly;
  int? selectedAge;
  int? _selectedTypeId;
  int? _selectedBreedId;

  String sortBy = "DESC";

  Future<List<PetDetail>>? filteredPetsFuture;

  @override
  void initState() {
    super.initState();
    _initTypes();
    _applyFilters();
  }

  Future<void> _initTypes() async {
    _types = await petService.getAllPetTypes();
    setState(() {});
  }

  void _applyFilters() {
    final filters = petService.searchPets(
      name: name,
      typeId: _selectedTypeId,
      breedId: _selectedBreedId,
      gender: selectedGender,
      isVaccinated: isVaccinated,
      isSpayed: isSpayed,
      isKidFriendly: isKidFriendly,
      age: selectedAge,
      order: sortBy,
    );
    // final filters = petService.getAllPets();
    setState(() {
      filteredPetsFuture = filters;
    });
    }
    

  Future<void> _onTypeSelected(int? typeId, void Function(void Function()) modalSetState) async {
    _selectedTypeId = typeId;
    _selectedBreedId = null;
    _breeds = typeId != null ? await petService.getBreedsByType(typeId) : [];
    modalSetState(() {});
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        String? tempGender = selectedGender;
        bool? tempVaccinated = isVaccinated;
        bool? tempSpayed = isSpayed;
        bool? tempKidFriendly = isKidFriendly;
        int? tempAge = selectedAge;
        int? tempType = _selectedTypeId;
        int? tempBreed = _selectedBreedId;
        String tempSort = sortBy;

        return StatefulBuilder(
          builder: (context, modalSetState) {
            return Padding(
              padding: const EdgeInsets.all(16.0).copyWith(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Filter Pets", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<int>(
                      value: tempType,
                      decoration: const InputDecoration(labelText: "Pet Type"),
                      items: _types.map((type) {
                        return DropdownMenuItem(
                          value: type.id,
                          child: Text(type.name),
                        );
                      }).toList(),
                      onChanged: (val) async {
                        tempType = val;
                        await _onTypeSelected(val, modalSetState);
                        modalSetState(() => tempType = val);
                      },
                    ),

                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: tempBreed,
                      decoration: const InputDecoration(labelText: "Breed"),
                      items: _breeds.map((breed) {
                        return DropdownMenuItem(
                          value: breed.id,
                          child: Text(breed.name),
                        );
                      }).toList(),
                      onChanged: (val) => modalSetState(() => tempBreed = val),
                    ),

                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: "Gender"),
                      value: tempGender,
                      items: ['Male', 'Female']
                          .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                          .toList(),
                      onChanged: (value) => modalSetState(() => tempGender = value),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: const Text("Vaccinated"),
                      value: tempVaccinated ?? false,
                      onChanged: (value) => modalSetState(() => tempVaccinated = value),
                    ),
                    SwitchListTile(
                      title: const Text("Spayed/Neutered"),
                      value: tempSpayed ?? false,
                      onChanged: (value) => modalSetState(() => tempSpayed = value),
                    ),
                    SwitchListTile(
                      title: const Text("Kid Friendly"),
                      value: tempKidFriendly ?? false,
                      onChanged: (value) => modalSetState(() => tempKidFriendly = value),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: tempAge?.toString(),
                      decoration: const InputDecoration(labelText: "Max Age (years)"),
                      onChanged: (val) => modalSetState(() => tempAge = int.tryParse(val)),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: "Sort By"),
                      value: tempSort,
                      items: const [
                        DropdownMenuItem(value: "DESC", child: Text("Newest First")),
                        DropdownMenuItem(value: "ASC", child: Text("Oldest First")),
                      ],
                      onChanged: (val) => modalSetState(() => tempSort = val!),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedGender = tempGender;
                          isVaccinated = tempVaccinated;
                          isSpayed = tempSpayed;
                          isKidFriendly = tempKidFriendly;
                          selectedAge = tempAge;
                          sortBy = tempSort;
                          _selectedTypeId = tempType;
                          _selectedBreedId = tempBreed;
                        });
                        Navigator.pop(context);
                        _applyFilters();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Center(child: Text("Apply Filters")),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Pet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _openFilterSheet,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              onSubmitted: (value) {
                setState(() {
                  name = value.trim().isNotEmpty ? value.trim() : null;
                });
                _applyFilters();
              },
              decoration: InputDecoration(
                hintText: 'Search pets...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      name = null;
                    });
                    _applyFilters();
                  },
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<PetDetail>>(
              future: filteredPetsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: \${snapshot.error}'));
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
                      age: '${pet.age} year(s)',
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
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
