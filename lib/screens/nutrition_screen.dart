import 'package:flutter/material.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition Tracking')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCalorieCard(),
              const SizedBox(height: 20),
              _buildNutrientCards(),
              const SizedBox(height: 20),
              _buildMealsList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add meal tracking functionality
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCalorieCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Daily Calories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCalorieInfo('Consumed', '1,200', Colors.blue),
                _buildCalorieInfo('Remaining', '800', Colors.green),
                _buildCalorieInfo('Goal', '2,000', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieInfo(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildNutrientCards() {
    return Row(
      children: [
        Expanded(child: _buildNutrientCard('Protein', '65g', Colors.red)),
        Expanded(child: _buildNutrientCard('Carbs', '200g', Colors.brown)),
        Expanded(child: _buildNutrientCard('Fat', '55g', Colors.yellow)),
      ],
    );
  }

  Widget _buildNutrientCard(String nutrient, String amount, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(nutrient, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(
              amount,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Meals',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildMealItem('Breakfast', '420 kcal', 'Oatmeal with fruits'),
        _buildMealItem('Lunch', '550 kcal', 'Grilled chicken salad'),
        _buildMealItem('Dinner', '230 kcal', 'Vegetable soup'),
      ],
    );
  }

  Widget _buildMealItem(String meal, String calories, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(meal),
        subtitle: Text(description),
        trailing: Text(
          calories,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
