class ModelAddTailor {
  String? name;
  String? email;
  ModelAddTailor({required this.name, required this.email});

  static String keyName = 'name';
  static String keyEmail = 'email';

  Map<String, dynamic> toMap() {
    return {
      keyName: name,
      keyEmail: email,
    };
  }
}
