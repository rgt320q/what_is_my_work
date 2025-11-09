import 'dart:convert';

class User {
  final String username;
  final DateTime loginTime;

  User({required this.username, DateTime? loginTime})
    : loginTime = loginTime ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'username': username,
    'loginTime': loginTime.toIso8601String(),
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    username: json['username'] as String,
    loginTime: DateTime.parse(json['loginTime'] as String),
  );

  static String encode(User user) => json.encode(user.toJson());
  static User decode(String user) => User.fromJson(json.decode(user));
}
