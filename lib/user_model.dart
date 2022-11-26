
/// Thought I would need this. Maybe not. Keeping it in the file for now.
class UserModel {
  late String uid;
  late String name;
  late String email;
  late String profileImage;
  late int dt;

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.profileImage,
      required this.dt});

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      profileImage: map['profileImage'],
      dt: map['dt'],
    );
  }
}
