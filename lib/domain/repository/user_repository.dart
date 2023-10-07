import 'dart:io';

import 'package:dispatch/domain/model/personal_data_model.dart';
import 'package:dispatch/domain/model/user_model.dart';

abstract interface class IUserRepository {
  void connect();
  void disconnect();

  Future<void> updateName(String name);
  Future<void> updateImage(File imageFile);
  Future<void> updatePersonalData(PersonalDataChecker checker);

  Stream<UserModel> getUserStream({required String email});
  Future<List<UserModel>> getUsersByQuery(String query);
}
