class Meal {
  Meal({
    this.id,
    this.name,
    this.calories,
    this.category,
  });

  Meal.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        name = json['name'] as String?,
        calories = json['calories'] as int?,
        category = json['category'] as String?;

  final String? id;
  final String? name;
  final int? calories;
  final String? category;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'calories': calories,
        'category': category,
      };

  Meal copyWith({
    String? id,
    String? name,
    int? calories,
    String? category,
  }) =>
      Meal(
        id: id ?? this.id,
        name: name ?? this.name,
        calories: calories ?? this.calories,
        category: category ?? this.category,
      );
}
