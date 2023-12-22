class UserDetailsP {
  String? profileImageURL = '';
  String? name = '';
  String? email = '';
  String? homeAddress = '';
  String? phoneNumber = '';

  UserDetailsP({
    this.profileImageURL,
    this.name,
    this.email,
    this.homeAddress,
    this.phoneNumber,
  });

  UserDetailsP.fromJson(Map<String, dynamic> json) {
    profileImageURL = json['profileImageURL'];
    name = json['name'];
    email = json['email'];
    homeAddress = json['homeAddress'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() => {
        'profileImageURL': profileImageURL,
        'name': name,
        'email': email,
        'homeAddress': homeAddress,
        'phoneNumber': phoneNumber,
      };
}
