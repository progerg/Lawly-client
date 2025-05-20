class LawyerReqCreateEntity {
  final String description;

  final List<int>? documentBytes;

  LawyerReqCreateEntity({
    required this.description,
    this.documentBytes,
  });
}
