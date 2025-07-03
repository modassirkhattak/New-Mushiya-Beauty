class UpdateCustomerMdoel {
  final int id;
  final String firstName;
  final String? note;

  UpdateCustomerMdoel({required this.id, required this.firstName, this.note});

  Map<String, dynamic> toJson() {
    return {
      "customer": {
        "id": id,
        "first_name": firstName,
        "note": note ?? "",
        "metafields": [
          {
            "key": "new",
            "value": "newvalue",
            "type": "single_line_text_field",
            "namespace": "global",
          },
        ],
      },
    };
  }
}
