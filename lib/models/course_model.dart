class CourseModel {
  final String id;
  final String title;
  final String description;
  final String image;
    final String sectionType;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
     required this.sectionType,
  });

 factory CourseModel.fromJson(
  Map<String, dynamic> json,
) {

  return CourseModel(

    id: json["_id"]?.toString() ?? "",

    title: json["name"]?.toString() ?? "",

    description:
        json["description"]?.toString() ?? "",

    image: json["image"]?.toString() ?? "",

    sectionType: json["sectionType"]?.toString() ?? "",
  );
}
}