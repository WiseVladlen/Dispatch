import 'package:dispatch/data/database.dart' as generated;
import 'package:dispatch/data/mapper/user_mapper.dart';
import 'package:dispatch/domain/model/user_model.dart';
import 'package:drift/drift.dart';

class UserLocalDataSource {
  const UserLocalDataSource({required this.db});

  final generated.Database db;

  Future<void> upsertAuthenticatedUser(AuthenticatedUserModel user) async {
    await db.into(db.userTable).insert(user.toDatabaseUser(), mode: InsertMode.replace);
  }

  /// Returns the first authenticated user in the list in the record format (user, accessToken).
  ///
  /// If the user is not found, it returns a null record.
  Future<AuthenticatedUserModel?> getAuthenticatedUser() async {
    final result = db.select(db.userTable)..where((table) => table.accessToken.isNotNull());
    return (await result.getSingleOrNull())?.toAuthenticatedUserModel();
  }

  Stream<UserModel> getUserStream(String email) {
    return (db.select(db.userTable)..where((table) => table.email.equals(email)))
        .map((user) => user.toUserModel())
        .watchSingle();
  }

  Future<void> updateUser(UserModel user) async {
    await (db.update(db.userTable)..where((table) => table.email.equals(user.email)))
        .write(user.toDatabaseUser());
  }

  Future<void> updateAccessToken(String email, [String? value]) async {
    await (db.update(db.userTable)..where((table) => table.email.equals(email)))
        .write(generated.UserTableCompanion(accessToken: Value(value)));
  }

  Future<void> removeAccessToken(String email) async => await updateAccessToken(email);
}
