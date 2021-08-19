import 'package:shared_preferences/shared_preferences.dart';
import '../../model/app_user.dart';

class UserLocalData {
  static late SharedPreferences? _preferences;
  static Future<void> init() async =>
      _preferences = await SharedPreferences.getInstance();

  static void signout() => _preferences!.clear();

  static const String _uidKey = 'UIDKEY';
  static const String _emailKey = 'EMAILKEY';
  static const String _displayNameKey = 'DISPLAYNAMEKEY';
  static const String _imageUrlKey = 'IMAGEURLKEY';

  //s
  // Setters
  //
  static Future<void> setUserUID(String uid) async =>
      _preferences!.setString(_uidKey, uid);

  static Future<void> setUserEmail(String email) async =>
      _preferences!.setString(_emailKey, email);

  static Future<void> setUserDisplayName(String name) async =>
      _preferences!.setString(_displayNameKey, name);

  static Future<void> setUserImageUrl(String url) async =>
      _preferences!.setString(_imageUrlKey, url);

  //
  // Getters
  //
  static String get getUserUID => _preferences!.getString(_uidKey) ?? '';
  static String get getUserEmail => _preferences!.getString(_emailKey) ?? '';
  static String get getUserDisplayName =>
      _preferences!.getString(_displayNameKey) ?? '';
  static String get getUserImageUrl =>
      _preferences!.getString(_imageUrlKey) ?? '';

  void storeAppUserData({required AppUser appUser}) {
    setUserUID(appUser.uid);
    setUserEmail(appUser.email);
    setUserDisplayName(appUser.displayName);
    setUserImageUrl(appUser.imageURL);
  }
}
