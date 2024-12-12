import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Const/apiconfig.dart';
import '../Const/error_handler.dart';
import '../Const/shared_preferences.dart';
import '../Model/task_model.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _allTasks = [];
  List<Task> _visibleTasks = [];
  final int _itemsPerPage = 10;
  int _currentPage = 1;
  bool _isLoading = false;
  String? _errorMessage;

  List<Task> get visibleTasks => _visibleTasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _visibleTasks.length < _allTasks.length;

//fetch task
  Future<void> fetchTasks() async {
    if (_isLoading) return;

    String? token = await Store.getFcmtoken();

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse(ApiConfig.taskUrl);
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        },
      );

      if (response.statusCode == 200) {
        final data = taskResponseFromJson(response.body);
        _allTasks = data.data;
        _loadMoreTasks(); // Load the first page
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

  //load more data

  void _loadMoreTasks() {
    final nextTasks = _allTasks
        .skip((_currentPage - 1) * _itemsPerPage)
        .take(_itemsPerPage)
        .toList();
    _visibleTasks.addAll(nextTasks);
    _currentPage++;
    notifyListeners();
  }

  void loadMore() {
    if (hasMore) {
      _loadMoreTasks();
    }
  }

  void resetTasks() {
    _visibleTasks = [];
    _currentPage = 1;
    notifyListeners();
  }

  // add task

  Future<void> addTask(String name, String description, String deadline,
      String status, int from, int id) async {
    final url = Uri.parse(from == 1
        ? ApiConfig.updatetaskurl + id.toString()
        : ApiConfig.addtaskurl);
    String? token = await Store.getFcmtoken();
    final body = {
      "name": name,
      "description": description,
      "deadline": deadline,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        notifyListeners();
      } else {
        throw Exception(
            from == 1 ? 'Failed to update task' : 'Failed to add task');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // delete Task

  Future<void> deleteitem(int id) async {
    final url = Uri.parse(ApiConfig.deletetask + id.toString());
    String? token = await Store.getFcmtoken();

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        notifyListeners();
      } else {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
