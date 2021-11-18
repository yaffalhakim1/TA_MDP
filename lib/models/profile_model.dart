class ProfileModel {
  final String login;
  final int id;
  final String image;
  final int followers;
  final String repo;
  final String name;
  final String company;
  final String blog;
  final String location;
  final String bio;
  final int repos;
  final int following;
  ProfileModel({
    this.login,
    this.id,
    this.image,
    this.followers,
    this.repo,
    this.name,
    this.company,
    this.blog,
    this.location,
    this.bio,
    this.repos,
    this.following,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      login: json['login'],
      id: json['id'],
      image: json['avatar_url'],
      followers: json['followers'],
      repos: json['public_repos'],
      name: json['name'],
      company: json['company'],
      blog: json['blog'],
      location: json['location'],
      bio: json['bio'],
      following: json['following'],
    );
  }
}
