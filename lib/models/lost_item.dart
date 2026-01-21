class LostItem {
  final String? id;
  final String name;
  final String place;
  final String time;
  final String category;
  final String image;
  final String description;
  final String phone;
  final String? userId;
  final String? userName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LostItem({
    this.id,
    required this.name,
    required this.place,
    required this.time,
    required this.category,
    required this.image,
    required this.description,
    required this.phone,
    this.userId,
    this.userName,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'place': place,
      'time': time,
      'category': category,
      'image': image,
      'description': description,
      'phone': phone,
      'user_id': userId,
      'user_name': userName,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory LostItem.fromJson(Map<String, dynamic> json) {
    return LostItem(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      place: json['place'] as String? ?? '',
      time: json['time'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
      description: json['description'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      userId: json['user_id'] as String?,
      userName: json['user_name'] as String?,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  LostItem copyWith({
    String? id,
    String? name,
    String? place,
    String? time,
    String? category,
    String? image,
    String? description,
    String? phone,
    String? userId,
    String? userName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LostItem(
      id: id ?? this.id,
      name: name ?? this.name,
      place: place ?? this.place,
      time: time ?? this.time,
      category: category ?? this.category,
      image: image ?? this.image,
      description: description ?? this.description,
      phone: phone ?? this.phone,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

