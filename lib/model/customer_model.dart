// STEP 1: Create the model class
class CustomerModel {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String state;
  final String note;

  CustomerModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.state,
    required this.note,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'],
      state: json['state'] ?? '',
      note: json['note'] ?? '',
    );
  }
}
