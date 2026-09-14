class UserModel {
  final String uid;
  final String email;

  UserModel({required this.uid, required this.email});

  // Factory constructor to create a UserModel from a Firebase User
  factory UserModel.fromFirebase(dynamic firebaseUser) {
    return UserModel(uid: firebaseUser.uid, email: firebaseUser.email ?? '');
  }

  // Convert to Map if needed for database storage
  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email};
  }
}
