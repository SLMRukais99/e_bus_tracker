class UserDetails {
  String? profileImageURL = '';
  String? name = '';
  String? route = '';
  String? busNo = '';
  String? phoneNumber = '';
  String? email = '';

  UserDetails({
    this.profileImageURL,
    this.name,
    this.route,
    this.busNo,
    this.phoneNumber,
    this.email,
  });
  UserDetails.fromJson(Map<String, dynamic> json) {
    profileImageURL = json['profileImageURL'];
    name = json['name'];
    route = json['route'];
    busNo = json['busNo'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
  }
  Map<String, dynamic> toJson() => {
        'profileImageURL': profileImageURL,
        'name': name,
        'route': route,
        'busNo': busNo,
        'phoneNumber': phoneNumber,
        'email': email,
      };
}
