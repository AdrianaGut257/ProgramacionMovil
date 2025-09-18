class Player {
  final int id;
  final String name;
  final int score;

  Player({required this.id, required this.name, required this.score});

  // factory Player.fromMap(Map<String, dynamic> map) {
  //   final idVal = map['id'];
  //   final nameVal = map['name'];

  //   final int id = idVal is int
  //       ? idVal
  //       : (idVal is String ? int.tryParse(idVal) ?? 0 : 0);

  //   final String name = nameVal?.toString() ?? '';

  //   return Player(id: id, name: name);
  // }

  // Map<String, dynamic> toMap() => {'id': id, 'name': name};
}
