class UsersModel {
  String id, name, email, address, semester, profilePic;
  List<dynamic> selectedCourses;
  UsersModel(
      {required this.id,
      required this.name,
      required this.address,
      required this.email,
      required this.selectedCourses,
      required this.semester,
      required this.profilePic});
}
