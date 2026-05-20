class CategoryModel {

  final String id;
  final String title;
  final String image;
  final String description;
  final String key;

  CategoryModel({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.key,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {

    return CategoryModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      key: json['key'] ?? '',
    );
  }
}