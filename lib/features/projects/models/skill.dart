class Skill {
  final String id;
  final String name;
  final String iconAssetName; // For SVGs or Images local assets. Or could be a URL.

  Skill({
    required this.id,
    required this.name,
    required this.iconAssetName,
  });

  factory Skill.fromMap(Map<String, dynamic> map, String id) {
    return Skill(
      id: id,
      name: map['name'] ?? '',
      iconAssetName: map['iconAssetName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconAssetName': iconAssetName,
    };
  }
}
