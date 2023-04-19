import 'package:get/get.dart';
import 'package:proyecto/users/preferencias/preferencias.dart';

import '../model/User.dart';

class actual extends GetxController{
  final Rx<User> _currentUser = User(0,0,0,0,0, "", "", "").obs;

  User get user => _currentUser.value;

  getUserInfo() async
  {
    User? getUserInfoFromLocalStorage = await preferencias.redUserInfo();
    _currentUser.value = getUserInfoFromLocalStorage!;
  }

}

