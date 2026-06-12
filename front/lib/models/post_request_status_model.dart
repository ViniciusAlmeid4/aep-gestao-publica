class PostRequestStatusModel {
  final String status;
  final String description;

  PostRequestStatusModel({required this.status, required this.description});

  Map<String, dynamic> toJson() {
    return {'status': status, 'description': description};
  }
}
