import 'package:shared_preferences/shared_preferences.dart';

class StoreData implements _CacheKey {
  static final StoreData instant = StoreData._internal();

  StoreData._internal();

  late SharedPreferences pref;

  Future<void> initCache() async {
    pref = await SharedPreferences.getInstance();
  }

  String get token => pref.getString(_CacheKey.token) ?? '';
  Future<void> setToken(String token) => pref.setString(_CacheKey.token, token);

  String get refreshToken => pref.getString(_CacheKey.refreshToken) ?? '';
  Future<void> setRefreshToken(String refreshToken) =>
      pref.setString(_CacheKey.refreshToken, refreshToken);

  Future removeAllCache() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(_CacheKey.token);
    await preferences.remove(_CacheKey.refreshToken);
  }
}

abstract class _CacheKey {
  _CacheKey._internal();

  static const String token = "xToken";
  static const String refreshToken = "xTokenRefresh";
}
