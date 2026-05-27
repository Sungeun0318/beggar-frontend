class User {
  final int no;
  final String name;
  final String email;

  const User({required this.no, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) => User(
        no: json['no'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
      );

  Map<String, dynamic> toJson() => {'no': no, 'name': name, 'email': email};
}
