class Users {
  String uid;
  String name;
  String email;
  String username;
  String status;
  int state;
  String profilePhoto;
  String firebaseToken;

  Users({
    this.uid,
    this.name,
    this.email,
    this.username,
    this.status,
    this.state,
    this.profilePhoto,
    this.firebaseToken,
  });

  Map toMap(Users users) {
    var data = Map<String, dynamic>();
    data['uid'] = users.uid;
    data['name'] = users.name;
    data['email'] = users.email;
    data['username'] = users.username;
    data["status"] = users.status;
    data["state"] = users.state;
    data["profile_photo"] = users.profilePhoto;
    data["firebaseToken"] = users.firebaseToken;
    return data;
  }

  // Named constructor
  Users.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.state = mapData['state'];
    this.profilePhoto = mapData['profile_photo'];
    this.firebaseToken = mapData['firebaseToken'];
  }
}
