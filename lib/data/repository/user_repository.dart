import 'dart:io';

import 'package:dispatch/data/local_data_source/user_local_data_source.dart';
import 'package:dispatch/data/remote_data_source/user_remote_data_source.dart';
import 'package:dispatch/domain/model/personal_data_model.dart';
import 'package:dispatch/domain/model/user_model.dart';
import 'package:dispatch/domain/repository/user_repository.dart';

class UserRepository implements IUserRepository {
  const UserRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  final UserLocalDataSource localDataSource;
  final UserRemoteDataSource remoteDataSource;

  @override
  void connect() => remoteDataSource.updateOnlineStatus(isOnline: true);

  @override
  void disconnect() => remoteDataSource.updateOnlineStatus(isOnline: false);

  @override
  Future<void> updateName(String name) async {
    final user = await remoteDataSource.updateName(name);
    await localDataSource.updateUser(user);
  }

  @override
  Future<void> updateImage(File imageFile) async {
    final user = await remoteDataSource.updateImage(imageFile);
    await localDataSource.updateUser(user);
  }

  @override
  Future<void> updatePersonalData(PersonalDataChecker checker) async {
    final user = await remoteDataSource.updatePersonalData(checker);
    await localDataSource.updateUser(user);
  }

  @override
  Stream<UserModel> getUserStream({required String email}) => localDataSource.getUserStream(email);

  @override
  Future<List<UserModel>> getUsersByQuery(String query) async {
    return await remoteDataSource.getUsersByQuery(query);
  }
}
