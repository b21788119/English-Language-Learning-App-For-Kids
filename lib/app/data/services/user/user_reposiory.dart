import 'package:first_app/app/data/models/user.dart';
import 'package:first_app/app/data/providers/user/provider.dart';

class UserRepository {
  UserProvider userProvider;

  UserRepository({
    required this.userProvider,
  });

  Future<User> readUser() async {
    User user = await userProvider.readUser();
    return user;
  }
}
