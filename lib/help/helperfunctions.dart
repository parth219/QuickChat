import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String userIdKey = "userIdKey";
  static String userNameKey = "userNameKey";
  static String displayNameKey = "displayNameKey";
  static String userEmailKey = "userEmailKey";
  static String userProfileKey = "userProfileKey";

//saving data to SharedPrefernce
  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userNameKey, getUserName);
  }

  Future<bool> saveDisplayName(String getDisplayName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(displayNameKey, getDisplayName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserProfile(String getUserProfile) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userProfileKey, getUserProfile);
  }

//GEtting data from SHaredPreference

  Future<String> getuserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(userIdKey);
  }

  Future<String> getuserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(userNameKey);
  }

  Future<String> getDisplayName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(displayNameKey);
  }

  Future<String> getUserEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(userEmailKey);
  }

  Future<String> getUserProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(userProfileKey);
  }
}
