import 'package:get/get.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  final user = UserModel.empty.obs;

  void setUser(UserModel newUser) {
    user.value = newUser;
  }

  void updateUser(UserModel updatedUser) {
    user.value = updatedUser;
  }
}
