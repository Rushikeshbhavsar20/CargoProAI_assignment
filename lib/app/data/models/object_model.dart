class ObjectModel {
  final String id;
  final String name;
  final Map<String, dynamic>? data;
  ObjectModel({required this.id, required this.name, this.data});

  factory ObjectModel.fromJson(Map<String, dynamic> json) {
    return ObjectModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic> ? (json['data'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, if (data != null) 'data': data};
}
