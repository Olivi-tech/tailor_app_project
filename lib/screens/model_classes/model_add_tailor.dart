class ModelAddTailor {
  String name;
  ModelAddTailor({required this.name});

  String keyName = 'name';

  Map<String, dynamic> toMap() {
    return {
      keyName: name,
    };
  }
}
