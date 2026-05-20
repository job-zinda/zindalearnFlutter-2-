class FeedbackModel {

  final String id;
  final String name;
  final String course;
  final String message;

  FeedbackModel({
    required this.id,
    required this.name,
    required this.course,
    required this.message,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {

    return FeedbackModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "Student",
      course: json["course"] ?? "",
      message: json["message"] ?? "",
    );
  }
}