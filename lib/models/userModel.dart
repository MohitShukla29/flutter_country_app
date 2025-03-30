class UserModel {
  String uid;
  String fullName;
  String email;
  String profilePictureUrl;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.profilePictureUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      profilePictureUrl: map['profilePictureUrl'] ?? '',
    );
  }
}
