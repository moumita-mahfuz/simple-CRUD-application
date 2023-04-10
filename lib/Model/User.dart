//{id: 1, login: admin, firstName: Administrator, lastName: Administrator,
// email: admin@localhost.com, phone: +8801795888218, imageUrl: https://firebasestorage.googleapis.com/v0/b/inventory-51bca.appspot.com/o/test%2Fd61a99ea-32e2-4593-a2b8-131c89306f32.jpg?alt=media&token=d61a99ea-32e2-4593-a2b8-131c89306f32.jpg,
// activated: true, langKey: en, createdBy: system, createdDate: null, lastModifiedBy: admin,
// lastModifiedDate: 2023-03-25T14:44:13.198288Z, authorities: [ROLE_USER, ROLE_ADMIN]}
class User{
  User({
    required this.id,
    required this.login,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.imageUrl,
    required this.activated,
    required this.langKey,
    required this.createdBy,
    required this.createdDate,
    required this.lastModifiedBy,
    required this.lastModifiedDate,
    required this.authorities,
});
  int? id;
  String? login;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? imageUrl;
  bool? activated;
  String? langKey;
  String? createdBy;
  String? createdDate;
  String? lastModifiedBy;
  String? lastModifiedDate;
  List<dynamic>? authorities;
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    login: json['login'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    email: json['email'],
    phone: json['phone'],
    imageUrl: json['imageUrl'],
    activated: json['activated'],
    langKey: json['langKey'],
    createdBy: json['createdBy'],
    createdDate: json['createdDate'],
    lastModifiedBy: json['lastModifiedBy'],
    lastModifiedDate: json['lastModifiedDate'],
      authorities: json['authorities'],
  );
  Map<String, dynamic> toJson() => {
  'id': id,
  'login': login,
  'firstName': firstName,
  'lastName': lastName,
  'email': email,
  'phone': phone,
  'imageUrl': imageUrl,
  'activated': activated,
  'langKey': langKey,
  'createdBy': createdBy,
  'createdDate': createdDate,
  'lastModifiedBy': lastModifiedBy,
  'lastModifiedDate': lastModifiedDate,
  'authorities': authorities,
  };


}