import 'package:shared_preferences/shared_preferences.dart';

 class PrefManager {
 
  final String _userNamePrefs = "user_name_pref";
  final String _kSortingOrderPrefs = "sortOrder";

  Future<String> getUserName() async {
	final SharedPreferences prefs = await SharedPreferences.getInstance();
  	return prefs.getString(_userNamePrefs);
  }

  Future<bool> setUserName(String value) async {
	final SharedPreferences prefs = await SharedPreferences.getInstance();
	return prefs.setString(_userNamePrefs, value);
  }

  Future<String> getSortingOrder() async {
	final SharedPreferences prefs = await SharedPreferences.getInstance();
	return prefs.getString(_kSortingOrderPrefs) ?? 'name';
  }

  Future<bool> setSortingOrder(String value) async {
	final SharedPreferences prefs = await SharedPreferences.getInstance();
	return prefs.setString(_kSortingOrderPrefs, value);
  }
}
