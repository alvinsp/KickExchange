class ProfileModel {
  String? username;
  String? email;
  String? image;

  ProfileModel({this.username, this.email, this.image});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      username: json['username'],
      email: json['email'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'image': image,
    };
  }
}
