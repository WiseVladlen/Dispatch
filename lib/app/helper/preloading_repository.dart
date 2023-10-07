import 'package:dispatch/data/cache_storage.dart';
import 'package:dispatch/data/local_data_source/user_local_data_source.dart';
import 'package:dispatch/data/preference_storage.dart';
import 'package:dispatch/utils/object_utils.dart';

class PreloadingRepository {
  const PreloadingRepository({required this.userLocalDataSource});

  final UserLocalDataSource userLocalDataSource;

  Future<void> preload() async {
    await fetchIsLightTheme();
    await fetchAuthenticatedUser();
  }

  Future<void> fetchIsLightTheme() async {
    CacheStorage().isLightTheme = await PreferenceStorage().isLightTheme;
  }

  Future<void> fetchAuthenticatedUser() async {
    (await userLocalDataSource.getAuthenticatedUser()).safeLet((it) {
      CacheStorage()
        ..writeUser(it.user)
        ..writeAccessToken(it.accessToken);
    });
  }
}
