import 'package:ceinture/core/utils/translations_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  final String _kNotificationsPrefs = "allowNotifications";
  final String _kSortingOrderPrefs = "sortOrder";
  final String userId = "userID";
  final String userEmail = "userEmail";
  final String userLanguage = "userLanguage";
  final String wifiName = "wifiName";
  final String wifiPsw = "wifipsw";
  final String serverPort = "serverPort";


  Future<bool> getAllowsNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_kNotificationsPrefs) ?? false;
  }

  Future<bool> setAllowsNotifications(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_kNotificationsPrefs, value);
  }

  Future<String> getSortingOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_kSortingOrderPrefs) ?? 'name';
  }

  Future<bool> setSortingOrder(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_kSortingOrderPrefs, value);
  }

  Future<String> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userId) ?? "";
  }

  Future<bool> setUserId(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(userId, value);
  }

  Future<String> getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(userEmail) ?? "";
  }

  Future<bool> setUserEmail(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(userEmail, value);
  }

  Future<bool> setLanguage(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await translationsUtils.setNewLanguage(value);
    return prefs.setString(userLanguage, value);
  }

  Future<String> getLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(userLanguage) ?? "";
  }
  Future<bool> setWifiName(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await translationsUtils.setNewLanguage(value);
    return prefs.setString(wifiName, value);
  }
  Future<String> getWifiName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(wifiName) ?? "";
  }
  Future<bool> setWifiPsw(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await translationsUtils.setNewLanguage(value);
    return prefs.setString(wifiPsw, value);
  }
  Future<String> getWifiPsw() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(wifiPsw) ?? "";
  }
  Future<bool> setServerPort(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await translationsUtils.setNewLanguage(value);
    return prefs.setString(serverPort, value);
  }
  Future<String> getServerPort() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(serverPort) ?? "";
  }
}