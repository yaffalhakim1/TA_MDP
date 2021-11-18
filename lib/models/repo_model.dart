class RepoModel {
  final int id;
  final String name;
  final String language;
  final bool fork;
  final bool private;

  RepoModel({this.id, this.name, this.language, this.fork, this.private});

  factory RepoModel.fromJson(Map<String, dynamic> json) {
    return RepoModel(
      id: json['id'],
      name: json['name'],
      language: json['language'],
      fork: json['fork'],
      private: json['private'],
    );
  }
}
