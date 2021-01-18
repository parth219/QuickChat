import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{

static String sharedPreferenceUserLoggedInKey="ISLOGGEDIN";
static String sharedPreferenceUserNameKey="USERNAME";
static String sharedPreferenceUserEmailKey="USEREMAILKEY";

//saving data to SharedPrefernce
static Future<bool> saveuserLoggedInSharedPreference(bool isUserLoggedIn) async{
  SharedPreferences preferences= await SharedPreferences.getInstance();
  await preferences.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
}

static Future<String> saveuserNameSharedPreference(String userName) async{
  SharedPreferences preferences= await SharedPreferences.getInstance();
  await preferences.setString(sharedPreferenceUserNameKey, userName);
}
static Future<String> saveuserEmailSharedPreference(String userEmail) async{
  SharedPreferences preferences= await SharedPreferences.getInstance();
  await preferences.setString(sharedPreferenceUserEmailKey, userEmail);
}

//GEtting data from SHaredPreference

static Future<bool> getuserLoggedInSharedPreference() async{
  SharedPreferences preferences= await SharedPreferences.getInstance();
  return  preferences.getBool(sharedPreferenceUserLoggedInKey);
}


static Future<String> getuserNameSharedPreference() async{
  SharedPreferences preferences= await SharedPreferences.getInstance();
  return  preferences.getString(sharedPreferenceUserLoggedInKey);
}

static Future<String> getuserEmailSharedPreference() async{
  SharedPreferences preferences= await SharedPreferences.getInstance();
  return  preferences.getString(sharedPreferenceUserLoggedInKey);
}





}