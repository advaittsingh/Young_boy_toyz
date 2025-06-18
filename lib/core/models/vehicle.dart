class Vehicle {
  final String id;
  final String title;
  final String make;
  final String model;
  final int year;
  final double price;
  final String location;
  final String category;
  final List<String> images;
  final String description;
  final List<String> modifications;
  final Map<String, dynamic> specifications;
  final String ownerId;
  final String ownerName;
  final Map<String, String> contactInfo;
  final DateTime createdAt;

  Vehicle({
    required this.id,
    required this.title,
    required this.make,
    required this.model,
    required this.year,
    required this.price,
    required this.location,
    required this.category,
    required this.images,
    required this.description,
    required this.modifications,
    required this.specifications,
    required this.ownerId,
    required this.ownerName,
    required this.contactInfo,
    required this.createdAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as String,
      title: json['title'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      price: (json['price'] as num).toDouble(),
      location: json['location'] as String,
      category: json['category'] as String,
      images: List<String>.from(json['images'] as List),
      description: json['description'] as String,
      modifications: List<String>.from(json['modifications'] as List),
      specifications: json['specifications'] as Map<String, dynamic>,
      ownerId: json['ownerId'] as String,
      ownerName: json['ownerName'] as String,
      contactInfo: Map<String, String>.from(json['contactInfo'] as Map),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'make': make,
      'model': model,
      'year': year,
      'price': price,
      'location': location,
      'category': category,
      'images': images,
      'description': description,
      'modifications': modifications,
      'specifications': specifications,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'contactInfo': contactInfo,
      'createdAt': createdAt.toIso8601String(),
    };
  }
} 