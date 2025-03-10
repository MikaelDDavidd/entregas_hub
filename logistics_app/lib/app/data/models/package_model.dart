class Package {
  final String id;
  final String trackingCode;
  final String ownerName;
  final String location;
  final bool synced;
  final String imagePath;
  final String imageUrl;

  Package({
    required this.id,
    required this.trackingCode,
    required this.ownerName,
    required this.location,
    required this.synced,
    required this.imagePath,
    required this.imageUrl,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['_id'],
      trackingCode: json['trackingCode'],
      ownerName: json['ownerName'],
      location: json['location'],
      synced: json['synced'],
      imagePath: json['imagePath'],
      imageUrl: json['imageUrl'], // Agora isso é apenas uma URL (String)
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'trackingCode': trackingCode,
      'ownerName': ownerName,
      'location': location,
      'synced': synced,
      'imagePath': imagePath,
      'imageUrl': imageUrl,
    };
  }
}