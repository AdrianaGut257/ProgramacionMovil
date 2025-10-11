// Archivo: lib/data/models/category.dart

class Category {
  final int? id;
  final String name;
  final List<String>? words;

  Category({this.id, required this.name, this.words});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int?,
      name: map['name'] as String,
      words: map['words'] != null
          ? List<String>.from(map['words'] as List)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'words': words};
  }

  Category copyWith({int? id, String? name, List<String>? words}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      words: words ?? this.words,
    );
  }

  @override
  String toString() =>
      'Category(id: $id, name: $name, words: ${words?.length ?? 0})';
}
