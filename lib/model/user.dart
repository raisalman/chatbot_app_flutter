import 'dart:convert';

class User {
  int? id;
  String? lastLogin;
  bool? isSuperuser;
  String? username;
  String? firstName;
  String? lastName;
  bool? isStaff;
  bool? isActive;
  String? dateJoined;
  String? uuid;
  String? email;
  String? phone;
  List<dynamic>? groups;
  List<dynamic>? userPermissions;

  User({this.id,
    this.lastLogin,
    this.isSuperuser,
    this.username,
    this.firstName,
    this.lastName,
    this.isStaff,
    this.isActive,
    this.dateJoined,
    this.uuid,
    this.email,
    this.phone,
  this.groups});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lastLogin = json['last_login'];
    isSuperuser = json['is_superuser'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    isStaff = json['is_staff'];
    isActive = json['is_active'];
    dateJoined = json['date_joined'];
    uuid = json['uuid'];
    email = json['email'];
    phone = json['phone'];
    groups=json['groups'];
    userPermissions=json['user_permissions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['last_login'] = lastLogin;
    data['is_superuser'] = isSuperuser;
    data['username'] = username;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['is_staff'] = isStaff;
    data['is_active'] = isActive;
    data['date_joined'] = dateJoined;
    data['uuid'] = uuid;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }

  @override
  String toString() {
    return 'User{id: $id, lastLogin: $lastLogin, isSuperuser: $isSuperuser, username: $username, firstName: $firstName, lastName: $lastName, isStaff: $isStaff, isActive: $isActive, dateJoined: $dateJoined, uuid: $uuid, email: $email, phone: $phone}';
  }

  static Map<String,dynamic> toMap(User user)=>
      <String,dynamic>{
    'id':user.id,
    'last_login':user.lastLogin,
    'is_superuser':user.isSuperuser,
    'username':user.username,
    'first_name':user.firstName,
    'last_name':user.lastName,
    'is_staff':user.isStaff,
    'is_active':user.isActive,
    'date_joined':user.dateJoined,
    'uuid':user.uuid,
    'email':user.email,
    'phone':user.phone,
  };

  static String serialize(User user)=>json.encode(User.toMap(user));

  static User deserialize(String json)=>User.fromJson(jsonDecode(json));
}
