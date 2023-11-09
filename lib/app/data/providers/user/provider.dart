import 'package:first_app/app/core/utils/DataHelper.dart';
import 'package:first_app/app/data/models/user.dart';

class UserProvider {
  Future<User> readUser() async {
    final List<Map<String, dynamic>> userMaps =
        await DataHelper.instance.getAll("User");

    List<User> users = List.generate(userMaps.length, (i) {
      return User.fromJson(userMaps[i]);
    });
    return users.first;
  }
}
