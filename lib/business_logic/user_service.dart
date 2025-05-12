import 'package:fureverhome/models/user_detail.dart';
import 'package:fureverhome/repositories/user_repository.dart';
import 'package:fureverhome/repositories/user_favorite_repository.dart';


class UserService {
    // Private constructor
  UserService._internal();

  // The single instance (lazily instantiated)
  static final UserService _instance = UserService._internal();

  // Public factory constructor
  factory UserService() => _instance;

  final UserRepository _userRepository = UserRepository();
  final FavoritesRepository _favoritesRepository = FavoritesRepository();

  // User detail
  // Fetch user details
  Future<UserDetail?> getUserDetails(int userId) async {
    return await _userRepository.getUserDetails(userId);
  }

  // Add a new user
  Future<int> addNewUser(UserDetail user) async {
    return await _userRepository.insertUser(user);
  }

  // Update user details
  Future<int> updateUserDetails(UserDetail user) async {
    return await _userRepository.updateUser(user);
  }

  // Delete a user
  Future<int> deleteUser(int userId) async {
    return await _userRepository.deleteUser(userId);
  }

  // User favorites
  // Fetch user favorites
  Future<List<int>> getUserFavorites(int userId) async {
    return await _favoritesRepository.getFavoritePetIds(userId);
  }

  // Add a pet to favorites
  Future<void> addFavorite(int userId, int petId) async {
    await _favoritesRepository.addFavorite(userId, petId);
  }

  // Remove a pet from favorites
  Future<void> removeFavorite(int userId, int petId) async {
    await _favoritesRepository.removeFavorite(userId, petId);
  }

}