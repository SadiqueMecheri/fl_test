import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class Store {
  const Store._();
  static const String _percentage = "percentage";
  static const String _no_of_task = "no_of_task";
  static const String _position = "position";
  static const String _name = "name";
  static const String _image = "image";
  static const String _isLoggedIn = "isLoggedIn";
  static const String _token = "token";

  static Future<void> setFcmtoken(String token) async {
    log("token added");
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_token, token);
  }

  static Future<String?> getFcmtoken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_token);
  }

  static Future<void> setpercentage(String percentage) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_percentage, percentage);
  }

  static Future<String?> getpercentage() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_percentage);
  }

  static Future<void> set_no_of_task(String no_of_task) async {
    log("registeruser added");
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_no_of_task, no_of_task);
  }

  static Future<String?> get_no_of_task() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_no_of_task);
  }

  static Future<void> setLoggedIn(String loggedvalue) async {
    log("logged added");
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_isLoggedIn, loggedvalue);
  }

  static Future<String?> getLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_isLoggedIn);
  }

  static Future<void> setPosition(String position) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_position, position);
  }

  static Future<String?> getPosition() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_position);
  }

  static Future<void> setName(String name) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_name, name);
  }

  static Future<String?> getName() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_name);
  }

  static Future<void> setImage(String image) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_image, image);
  }

  static Future<String?> getImage() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_image);
  }

  static Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
