import 'dart:convert';
import 'package:http/http.dart' as http;

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is http.Response) {
      switch (error.statusCode) {
        case 400:
          return 'Bad Request: Please check your input.';
        case 401:
          return 'Unauthorized: Invalid email or password.';
        case 403:
          return 'Forbidden: You do not have permission to access this resource.';
        case 404:
          return 'Not Found: The requested resource could not be found.';
        case 500:
          return 'Internal Server Error: Please try again later.';
        default:
          try {
            final errorData = json.decode(error.body);
            return errorData['message'] ?? 'An unexpected error occurred';
          } catch (_) {
            return 'An unexpected error occurred';
          }
      }
    } else if (error is Exception) {
      return 'Failed to connect to the server. Please try again later.';
    } else {
      return 'An unknown error occurred.';
    }
  }
}
