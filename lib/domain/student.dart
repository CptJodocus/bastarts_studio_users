class Student {
  Student({
    required this.uuid,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.present = false,
    this.parentName,
    this.parentSurname,
    this.parentEmail,
    this.paid,
  });

  final String uuid;
  final String firstName;
  final String lastName;
  final String email;
  final bool present;
  final bool? paid;

  final String? parentName;
  final String? parentSurname;
  final String? parentEmail;

  String get fullName => '$firstName $lastName';

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      uuid: json["uuid"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      present: json["present"],
      paid: json["paid"],
      parentName: json["parentName"],
      parentSurname: json["parenSurname"],
      parentEmail: json["parentEmail"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uuid": uuid,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "present": present,
      "paid": paid,
      "parentName": parentName,
      "parentSurname": parentSurname,
      "parentEmail": parentEmail,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Student &&
          runtimeType == other.runtimeType &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          email == other.email;

  @override
  int get hashCode => firstName.hashCode ^ lastName.hashCode ^ email.hashCode;
}
