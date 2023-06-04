class Post {
  final String id;
  final String title;
  final String description;

  Post({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Post.fromJson(Map<String, dynamic> json, String id) {
    return Post(
      id: id,
      title: json['title'],
      description: json['description'],
    );
  }
}