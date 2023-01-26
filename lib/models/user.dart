class MyUser {
  String? uid;
  String? fullName;
  String? email;
  String? userRole;

  // MyUser({required this.uid, required this.fullName, required this.email, required this.userRole});
  MyUser(
      {this.uid = '000000',
      this.fullName = 'noname',
      this.email = 'noemail',
      this.userRole = 'student'});

  // not using this currently
  MyUser.fromData(this.uid, Map<String, dynamic> data)
      : fullName = data['name'],
        email = data['email'],
        userRole = data['user_role'];

  MyUser.fromMap(Map data)
      : uid = 'uid',
        fullName = data['name'],
        email = data['email'],
        userRole = data['user_role'];

  set value(MyUser user) {
    uid = user.uid;
    fullName = user.fullName;
    email = user.email;
    userRole = user.userRole;
  }

  @override
  String toString() {
    return '$uid, $fullName, $email';
  }
}
