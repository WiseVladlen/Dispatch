import 'package:drift/drift.dart';

@DataClassName('User')
class UserTable extends Table {
  @override
  Set<Column<Object>> get primaryKey => <TextColumn>{email};

  TextColumn get email => text()();
  TextColumn get name => text()();
  TextColumn get imagePath => text().named('image_path').nullable()();
  TextColumn get accessToken => text().named('access_token').nullable()();
}
