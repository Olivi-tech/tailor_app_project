class ModelAddCustomer {
  ///for tailor
  String? tailorName;
  String? tailorEmail;

  ///for tailor's customers
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? address;
  String? neck;
  String? waist;
  String? armLength;
  String? biceps;
  String? wrist;
  String? length;
  String? thigh;
  String? chest;
  String? inseam;
  String? shoulder;
  String? calf;

  // String toString() {
  //   return 'ModelAddCustomer{fullName: $fullName, phoneNumber: $phoneNumber, address: $address, collar: $collar, waist: $waist, armLength: $armLength, biceps: $biceps, wrist: $wrist, length: $length, thigh: $thigh, chest: $chest, inseam: $inseam, shoulder: $shoulder, calf: $calf}';
  // }
  static String keyTailorName = 'tailorName';
  static String keytailorEmail = 'tailorEmail';

  static String keyFirstName = 'firstName';
  static String keyLastName = 'lastName';
  static String keyPhoneNumber = 'phoneNumber';
  static String keyAddress = 'address';
  static String keyNeck = 'neck';
  static String keyShoulder = 'shoulder';
  static String keyChest = 'chest';
  static String keyWaist = 'waist';
  static String keyArmLength = 'armLength';
  static String keyBiceps = 'biceps';
  static String keyWrist = 'wrist';
  static String keyInseam = 'inseam';
  static String keyThigh = 'thigh';
  static String keyLength = 'length';
  static String keyCalf = 'calf';

  ModelAddCustomer({
    this.tailorName,
    this.tailorEmail,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.address,
    this.shoulder,
    this.neck,
    this.chest,
    this.waist,
    this.armLength,
    this.biceps,
    this.wrist,
    this.length,
    this.thigh,
    this.inseam,
    this.calf,
  });

  @override
  String toString() {
    return 'ModelAddCustomer{firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, address: $address, collar: $neck, waist: $waist, armLength: $armLength, biceps: $biceps, wrist: $wrist, length: $length, thigh: $thigh, chest: $chest, inseam: $inseam, shoulder: $shoulder, calf: $calf}';
  }

  Map<String, dynamic> toMap() {
    return {
      keyTailorName: tailorName,
      keytailorEmail: tailorEmail,
      keyFirstName: firstName,
      keyLastName: lastName,
      keyPhoneNumber: phoneNumber,
      keyAddress: address,
      keyNeck: neck,
      keyChest: chest,
      keyShoulder: shoulder,
      keyWaist: waist,
      keyArmLength: armLength,
      keyBiceps: biceps,
      keyWrist: wrist,
      keyLength: length,
      keyThigh: thigh,
      keyInseam: inseam,
      keyCalf: calf
    };
  }
}
