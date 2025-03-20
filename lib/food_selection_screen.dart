import 'package:fat2fit/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

void main() {
  runApp(
    const MaterialApp(
      home: FoodSelectionScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class FoodSelectionScreen extends StatefulWidget {
  const FoodSelectionScreen({Key? key}) : super(key: key);

  @override
  _FoodSelectionScreenState createState() => _FoodSelectionScreenState();
}

class _FoodSelectionScreenState extends State<FoodSelectionScreen> {
  // State variables for checkboxes
  bool beef = false, lamb = false, veal = false, pork = false;
  bool chicken = false, turkey = false, duck = false;
  bool milk = false, yoghurt = false, cheese = false;
  bool fish = false, crab = false, scallops = false, clams = false;
  bool apple = false,
      date = false,
      pineapple = false,
      avocado = false,
      orange = false;
  bool rice = false, pasta = false, bread = false;

  // Helper: builds an individual checkbox tile
  Widget _buildCheckbox(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return CheckboxListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }

  // Helper: builds a section card with a title and grid of checkbox tiles
  Widget _buildSectionCard(String sectionTitle, List<Widget> checkboxTiles) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sectionTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: checkboxTiles,
            ),
          ],
        ),
      ),
    );
  }

  // Build the title text for the screen
  Widget _buildScreenTitle() {
    return const Text(
      'Choose the types of foods you like?',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  // AppBar with rounded bottom edges that fills the width
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
      child: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Text(
            'We want your health\n to be the best',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildScreenTitle(),
                const SizedBox(height: 16),
                // Lean meats section
                _buildSectionCard('Lean meats:', [
                  _buildCheckbox(
                    'Beef',
                    beef,
                    (val) => setState(() => beef = val ?? false),
                  ),
                  _buildCheckbox(
                    'Lamb',
                    lamb,
                    (val) => setState(() => lamb = val ?? false),
                  ),
                  _buildCheckbox(
                    'Veal',
                    veal,
                    (val) => setState(() => veal = val ?? false),
                  ),
                  _buildCheckbox(
                    'Pork',
                    pork,
                    (val) => setState(() => pork = val ?? false),
                  ),
                ]),
                const SizedBox(height: 16),
                // Poultry section
                _buildSectionCard('Poultry:', [
                  _buildCheckbox(
                    'Chicken',
                    chicken,
                    (val) => setState(() => chicken = val ?? false),
                  ),
                  _buildCheckbox(
                    'Turkey',
                    turkey,
                    (val) => setState(() => turkey = val ?? false),
                  ),
                  _buildCheckbox(
                    'Duck',
                    duck,
                    (val) => setState(() => duck = val ?? false),
                  ),
                ]),
                const SizedBox(height: 16),
                // Dairy products section
                _buildSectionCard('Dairy products:', [
                  _buildCheckbox(
                    'Milk',
                    milk,
                    (val) => setState(() => milk = val ?? false),
                  ),
                  _buildCheckbox(
                    'Yoghurt',
                    yoghurt,
                    (val) => setState(() => yoghurt = val ?? false),
                  ),
                  _buildCheckbox(
                    'Cheese',
                    cheese,
                    (val) => setState(() => cheese = val ?? false),
                  ),
                ]),
                const SizedBox(height: 16),
                // Fish and seafood section
                _buildSectionCard('Fish and seafood:', [
                  _buildCheckbox(
                    'Fish',
                    fish,
                    (val) => setState(() => fish = val ?? false),
                  ),
                  _buildCheckbox(
                    'Crab',
                    crab,
                    (val) => setState(() => crab = val ?? false),
                  ),
                  _buildCheckbox(
                    'Scallops',
                    scallops,
                    (val) => setState(() => scallops = val ?? false),
                  ),
                  _buildCheckbox(
                    'Clams',
                    clams,
                    (val) => setState(() => clams = val ?? false),
                  ),
                ]),
                const SizedBox(height: 16),
                // Fruits section
                _buildSectionCard('Fruits:', [
                  _buildCheckbox(
                    'Apple',
                    apple,
                    (val) => setState(() => apple = val ?? false),
                  ),
                  _buildCheckbox(
                    'Date',
                    date,
                    (val) => setState(() => date = val ?? false),
                  ),
                  _buildCheckbox(
                    'Pineapple',
                    pineapple,
                    (val) => setState(() => pineapple = val ?? false),
                  ),
                  _buildCheckbox(
                    'Avocado',
                    avocado,
                    (val) => setState(() => avocado = val ?? false),
                  ),
                  _buildCheckbox(
                    'Orange',
                    orange,
                    (val) => setState(() => orange = val ?? false),
                  ),
                ]),
                const SizedBox(height: 16),
                // Carbohydrates section
                _buildSectionCard('Carbohydrates:', [
                  _buildCheckbox(
                    'Rice',
                    rice,
                    (val) => setState(() => rice = val ?? false),
                  ),
                  _buildCheckbox(
                    'Pasta',
                    pasta,
                    (val) => setState(() => pasta = val ?? false),
                  ),
                  _buildCheckbox(
                    'Bread',
                    bread,
                    (val) => setState(() => bread = val ?? false),
                  ),
                ]),
                const SizedBox(height: 16),
                // Next button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 20,
                      ),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Handle next action here
                      Get.to(() =>  HomeScreen());
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
