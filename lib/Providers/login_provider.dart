import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Const/apiconfig.dart';
import '../Const/error_handler.dart';
import '../Const/shared_preferences.dart';
import '../Model/login_model.dart';
import '../Screens/dashboard.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  LoginResponse? _loginResponse;

  // Password visibility state
  bool _isPasswordVisible = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LoginResponse? get loginResponse => _loginResponse;

  // Getter for password visibility
  bool get isPasswordVisible => _isPasswordVisible;

  // Method to toggle password visibility
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    final url = Uri.parse(ApiConfig.loginUrl);

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _loginResponse = LoginResponse.fromJson(data);

        // Save datas in shared preferences
        Store.setLoggedIn("yes");
        Store.setFcmtoken(_loginResponse!.token);
        Store.setImage(_loginResponse!.image);
        Store.setName(_loginResponse!.name);
        Store.setPosition(_loginResponse!.position.toString());
        Store.set_no_of_task(_loginResponse!.noOfTask.toString());
        Store.setpercentage(_loginResponse!.percentage.toString());

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
        );
      } else {
        _errorMessage = ErrorHandler.getErrorMessage(response);
      }
    } catch (error) {
      _errorMessage = ErrorHandler.getErrorMessage(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
