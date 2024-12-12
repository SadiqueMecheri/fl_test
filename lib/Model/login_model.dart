class LoginResponse {
  String token;
  String image;
  String name;
  String position;
  int noOfTask;
  int percentage;

  LoginResponse({
    required this.token,
    required this.image,
    required this.name,
    required this.position,
    required this.noOfTask,
    required this.percentage,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json["token"],
        image: json["image"],
        name: json["name"],
        position: json["position"],
        noOfTask: json["no_of_task"],
        percentage: json["percentage"],
      );
}