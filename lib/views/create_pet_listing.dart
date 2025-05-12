import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fureverhome/models/pet_detail.dart';
import 'package:fureverhome/models/pet_image.dart';
import 'package:fureverhome/models/pet_type.dart';
import 'package:fureverhome/models/breed.dart';
import 'package:fureverhome/business_logic/pet_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fureverhome/business_logic/user_service.dart';

class CreatePetListingPage extends StatefulWidget {
  @override
  _CreatePetListingPageState createState() => _CreatePetListingPageState();
}

class _CreatePetListingPageState extends State<CreatePetListingPage> {
  final _formKey = GlobalKey<FormState>();

  final PetService _petService = PetService();
  final ImagePicker _picker = ImagePicker();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // Dropdown values
  List<PetType> _types = [];
  List<Breed> _breeds = [];
  PetType? _selectedType;
  Breed? _selectedBreed;
  String _selectedGender = 'Male';

  // Checkboxes
  bool _isVaccinated = false;
  bool _isSpayed = false;
  bool _isKidFriendly = false;

  // Images
  List<Uint8List> _selectedImages = [];

  bool isLoading = false;
  int? userId;

  Future<void> fetchUserData() async {
    setState(() => isLoading = true);

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final user = await UserService().getUserByFirebaseUid(currentUser.uid);

      if (user != null) {
        setState(() {
          userId = user.id;
        });
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
    _loadTypesAndBreeds();
  }
  

  Future<void> _loadTypesAndBreeds() async {
    try {
      print("Loading pet types...");
      _types = await _petService.getAllPetTypes();
      print("Pet types loaded: ${_types.length}");

      if (_types.isNotEmpty) {
        _selectedType = _types.first;
        _breeds = await _petService.getBreedsByType(_selectedType!.id);
        print("Breeds loaded: ${_breeds.length}");
        _selectedBreed = _breeds.isNotEmpty ? _breeds.first : null;
      }
      setState(() {});
    } catch (e) {
      print("Error loading types and breeds: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading data: ${e.toString()}")),
      );
    }
  }

  Future<void> _pickImages() async {
    final List<XFile>? files = await _picker.pickMultiImage();
    if (files != null) {
      final images = await Future.wait(files.map((file) => file.readAsBytes()));
      setState(() {
        _selectedImages = images;
      });
    }
  }

  Future<void> _submitPetForm() async {
    if (_selectedType == null || _selectedBreed == null || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a valid type and breed.")),
      );
      return;
    }
    
    if (!_formKey.currentState!.validate()) return;

    try {
      PetDetail newPet = PetDetail(
        id: 0,
        userId: userId!,
        petName: _nameController.text,
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        description: _descriptionController.text,
        location: _locationController.text,
        typeId: _selectedType!.id,
        breedId: _selectedBreed!.id,
        isVaccinated: _isVaccinated,
        isSpayed: _isSpayed,
        isKidFriendly: _isKidFriendly,
        createdAt: DateTime.now(),
        images: [],
      );

      List<Uint8List> petImages = _selectedImages;

      await _petService.addNewPet(newPet, petImages);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pet listing created successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Pet Listing'),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _types.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Pet Name'),
                      validator: (value) =>
                          value!.isEmpty ? 'Name is required' : null,
                    ),
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(labelText: 'Age(In year)'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Age is required' : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      items: ['Male', 'Female']
                          .map((g) => DropdownMenuItem(
                                value: g,
                                child: Text(g),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedGender = val!;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Gender'),
                    ),
                    DropdownButtonFormField<PetType>(
                      value: _selectedType,
                      items: _types
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type.name),
                              ))
                          .toList(),
                      onChanged: (PetType? newType) async {
                        setState(() {
                          _selectedType = newType;
                          _selectedBreed = null;
                          _breeds = [];
                        });
                        _breeds = await _petService.getBreedsByType(newType!.id);
                        _selectedBreed = _breeds.isNotEmpty ? _breeds.first : null;
                        setState(() {});
                      },
                      decoration: const InputDecoration(labelText: 'Type'),
                    ),
                    if (_breeds.isNotEmpty)
                      DropdownButtonFormField<Breed>(
                        value: _selectedBreed,
                        items: _breeds
                            .map((breed) => DropdownMenuItem(
                                  value: breed,
                                  child: Text(breed.name),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedBreed = val;
                          });
                        },
                        decoration: const InputDecoration(labelText: 'Breed'),
                      ),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Location(ex. Bangkok)'),
                      validator: (value) =>
                          value!.isEmpty ? 'Location is required' : null,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      title: const Text("Vaccinated"),
                      value: _isVaccinated,
                      onChanged: (val) {
                        setState(() {
                          _isVaccinated = val!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("Spayed/Neutered"),
                      value: _isSpayed,
                      onChanged: (val) {
                        setState(() {
                          _isSpayed = val!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("Kid Friendly"),
                      value: _isKidFriendly,
                      onChanged: (val) {
                        setState(() {
                          _isKidFriendly = val!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImages,
                      child: const Text("Pick Images"),
                    ),
                    Wrap(
                      spacing: 8,
                      children: _selectedImages
                          .map((img) => Image.memory(img, width: 80, height: 80))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitPetForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        child: const Text("Submit Listing"),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
