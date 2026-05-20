class SessionModel {

final String id;
final String title;
final List<Map<String, dynamic>> courses;

SessionModel({
required this.id,
required this.title,
required this.courses,
});

factory SessionModel.fromJson(
Map<String, dynamic> json,
) {


return SessionModel(

  id: json["_id"]?.toString() ?? "",

  title: json["title"]?.toString() ?? "",

courses: json["courses"] != null ? List<Map<String, dynamic>>.from( json["courses"], ) : [],
);


}
}
