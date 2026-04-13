class Project {
  final String id;
  final String title;
  final String shortDescription;
  final String fullDescription;
  final List<String> features;
  final List<String> imageUrls;
  final String? sourceCodeLink;
  final String? downloadLink;
  final bool isFeatured;
  final int viewCount;

  Project({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.features,
    required this.imageUrls,
    this.sourceCodeLink,
    this.downloadLink,
    this.isFeatured = false,
    this.viewCount = 0,
  });

  factory Project.fromMap(Map<String, dynamic> map, String id) {
    return Project(
      id: id,
      title: map['title'] ?? '',
      shortDescription: map['shortDescription'] ?? '',
      fullDescription: map['fullDescription'] ?? '',
      features: List<String>.from(map['features'] ?? []),
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      sourceCodeLink: map['sourceCodeLink'],
      downloadLink: map['downloadLink'],
      isFeatured: map['isFeatured'] ?? false,
      viewCount: map['viewCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'shortDescription': shortDescription,
      'fullDescription': fullDescription,
      'features': features,
      'imageUrls': imageUrls,
      'sourceCodeLink': sourceCodeLink,
      'downloadLink': downloadLink,
      'isFeatured': isFeatured,
      'viewCount': viewCount,
    };
  }
}
