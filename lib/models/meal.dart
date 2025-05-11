class Meal {
  final String name;
  final String description;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final List<String> ingredients;
  final List<String> steps;
  
  Meal({
    required this.name,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.ingredients,
    required this.steps,
  });
  
  factory Meal.fromJson(Map<String, dynamic> json) {
    List<String> ingredientsList = [];
    if (json['ingredients'] != null) {
      ingredientsList = List<String>.from(json['ingredients']);
    }
    
    List<String> stepsList = [];
    if (json['steps'] != null) {
      stepsList = List<String>.from(json['steps']);
    }
    
    return Meal(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      calories: json['calories']?.toDouble() ?? 0.0,
      protein: json['protein']?.toDouble() ?? 0.0,
      carbs: json['carbs']?.toDouble() ?? 0.0,
      fat: json['fat']?.toDouble() ?? 0.0,
      ingredients: ingredientsList,
      steps: stepsList,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'ingredients': ingredients,
      'steps': steps,
    };
  }
}
