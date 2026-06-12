import 'address.dart';

class PostRequestModel {
  final String category;
  final String description;
  final String linkedFile;
  final Address address;
  final bool isAnonymous;

  PostRequestModel({
    required this.category,
    required this.description,
    required this.linkedFile,
    required this.address,
    required this.isAnonymous,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'description': description,
      'linkedFile': linkedFile,
      'address': address.toJson(),
      'isAnonymous': isAnonymous,
    };
  }
}
