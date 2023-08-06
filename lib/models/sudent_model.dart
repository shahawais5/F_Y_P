
class StudentDetailModel {
  String studentName;
  String fatherName;
  String Class;
  String email;
  String dob;
  String address;
  String languages;
  String interest;
  String? profileImage; // To store the download URL of the uploaded profile image
  String AddresType;

  StudentDetailModel({
    required this.studentName,
    required this.fatherName,
    required this.Class,
    required this.email,
    required this.dob,
    required this.address,
    required this.languages,
    required this.interest,
    this.profileImage,
    required this.AddresType,
  });
}