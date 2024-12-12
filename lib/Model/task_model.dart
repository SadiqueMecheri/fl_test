import 'dart:convert';

TaskResponse taskResponseFromJson(String str) =>
    TaskResponse.fromJson(json.decode(str));

class TaskResponse {
  final int totalTasks;
  final int pendingTasks;
  final List<Task> data;

  TaskResponse({
    required this.totalTasks,
    required this.pendingTasks,
    required this.data,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    return TaskResponse(
      totalTasks: json["total_tasks"],
      pendingTasks: json["pending_tasks"],
      data: List<Task>.from(json["data"].map((x) => Task.fromJson(x))),
    );
  }
}

class Task {
  final int id;
  final String name;
  final String description;
  final int percentage;
  final String status;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.percentage,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      percentage: json["percentage"],
      status: json["status"],
    );
  }
}
