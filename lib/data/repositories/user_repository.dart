import 'package:template_app/data/data.dart';
import 'package:template_app/services/database_service.dart';

class UserRepository {
  UserRepository();

  // Get user from database (returns first user or creates default)
  Future<UserModel> getUser() async {
    final users = await DatabaseService.getAllUsers();
    if (users.isEmpty) {
      final userId = await DatabaseService.insertUser(defaultUser);
      return defaultUser.copyWith(id: userId);
    } else {
      return users.first;
    }
  }

  // Get user by ID
  Future<UserModel?> getUserById(int id) async {
    return await DatabaseService.getUser(id);
  }

  // Save user to database
  Future<UserModel> saveUser(UserModel user) async {
    if (user.id == null) {
      // Insert new user
      final userId = await DatabaseService.insertUser(user);
      return user.copyWith(id: userId);
    } else {
      // Update existing user
      await DatabaseService.updateUser(user);
      return user;
    }
  }

  // Delete user
  Future<void> deleteUser(int id) async {
    await DatabaseService.deleteUser(id);
  }

  // Get all users
  Future<List<UserModel>> getAllUsers() async {
    return await DatabaseService.getAllUsers();
  }
}

UserModel defaultUser = UserModel(
  name: 'Default User',
);
