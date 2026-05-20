
class TutorModel {
  final String id;
  final String name;
  final String image;
  final String qualification;
  final String experience;

  final double rating;
  final List<dynamic> reviews;
  final List<dynamic> subjects;
  final List<dynamic> categoryIds;

  TutorModel({
    required this.id,
    required this.name,
    required this.image,
    required this.qualification,
    required this.experience,
    required this.rating,
    required this.reviews,
    required this.subjects,
    required this.categoryIds,
  });

  factory TutorModel.fromJson(Map<String, dynamic> json) {
    return TutorModel(
      id: json["_id"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      image: json["photo"]?.toString() ?? "",
      qualification: json["qualification"]?.toString() ?? "",
      experience: json["experience"]?.toString() ?? "",

      rating: (json["rating"] is num)
          ? (json["rating"] as num).toDouble()
          : 0.0,

      reviews: json["reviews"] is List
          ? List.from(json["reviews"])
          : [],

      subjects: json["subjects"] is List
          ? List.from(json["subjects"])
          : [],

      categoryIds: json["categoryIds"] is List
          ? List.from(json["categoryIds"])
          : [],
    );
  }
}