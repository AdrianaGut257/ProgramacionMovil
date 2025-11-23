class Player {
  final int? id;
  final String name;
  final int score;
  final int team;

  Player({
    this.id,
    required this.name,
    this.score = 0,
    this.team = 1,
  });

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'] as int?,
      name: map['name'] ?? '',
      score: map['score'] ?? 0,
      team: map['team'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
  final map = {
    'name': name,
    'score': score,
    'team': team,
  };
  if (id != null) {
    map['id'] = id!;
  }
  return map;
}

}
