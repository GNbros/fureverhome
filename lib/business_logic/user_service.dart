import 'package:fureverhome/models/user_detail.dart';
import 'package:fureverhome/repositories/user_repository.dart';

class UserService {
  final UserRepository _userRepository = UserRepository();

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

}