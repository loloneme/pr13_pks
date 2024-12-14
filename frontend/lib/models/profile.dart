class Profile{
  final String userID;
  final String fullname;
  final String image;
  final String email;
  final String phone;

  Profile({
    required this.userID,
    required this.fullname,
    required this.image,
    required this.email,
    required this.phone
  });

  factory Profile.fromJson(Map<String, dynamic> json){
    return Profile(
      userID: json["user_id"] as String,
      fullname: json["fullname"] as String,
      image: json["user_image"] as String,
      email: json["email"] as String,
      phone: json["phone"] as String
    );
  }
}