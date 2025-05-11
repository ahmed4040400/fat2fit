import 'package:fat2fit/food_selection_screen.dart';
import 'package:fat2fit/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'controllers/nutrition_controller.dart';
import 'models/nutrition_models.dart';
import 'screens/nutrition_screen.dart';

class MoreInfoPage extends StatefulWidget {
  const MoreInfoPage({Key? key}) : super(key: key);

  @override
  State<MoreInfoPage> createState() => _MoreInfoPageState();
}

class _MoreInfoPageState extends State<MoreInfoPage> {
  // Form fields
  String? selectedLanguage = 'English';
  String? selectedFoodType = 'Mixed';
  String? selectedGender = 'Male';
  String? selectedActivityLevel = 'Sedentary';
  String? selectedBodyShape = 'Weight_loss';
  
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  // Form field error messages
  String? weightError;
  String? heightError;
  String? ageError;

  // Nutrition controller
  final nutritionController = Get.find<NutritionController>(); // Changed from Get.put to Get.find
  
  // Loading state
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: const Color(0xFF2E7D32),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              _buildFormCard(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.lightGreen,
      title: Text(
        "Tell Us More About You",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
          height: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: Container(
          height: 20,
          decoration: const BoxDecoration(
            color: Color(0xFF2E7D32),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Preferred Language", 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildSelectionCard(
                icon: Icons.language,
                text: 'English',
                isSelected: selectedLanguage == 'English',
                onTap: () {
                  setState(() => selectedLanguage = 'English');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSelectionCard(
                icon: Icons.translate,
                text: 'Arabic',
                isSelected: selectedLanguage == 'Arabic',
                onTap: () {
                  setState(() => selectedLanguage = 'Arabic');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFoodTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Food Preference", 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildSelectionCard(
                icon: Icons.restaurant_menu,
                text: 'Egyptian',
                isSelected: selectedFoodType == 'Egyptian',
                onTap: () {
                  setState(() => selectedFoodType = 'Egyptian');
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSelectionCard(
                icon: Icons.fastfood,
                text: 'American',
                isSelected: selectedFoodType == 'American',
                onTap: () {
                  setState(() => selectedFoodType = 'American');
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSelectionCard(
                icon: Icons.dinner_dining,
                text: 'Mixed',
                isSelected: selectedFoodType == 'Mixed',
                onTap: () {
                  setState(() => selectedFoodType = 'Mixed');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gender", 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildSelectionCard(
                icon: Icons.male,
                text: 'Male',
                isSelected: selectedGender == 'Male',
                onTap: () {
                  setState(() => selectedGender = 'Male');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSelectionCard(
                icon: Icons.female,
                text: 'Female',
                isSelected: selectedGender == 'Female',
                onTap: () {
                  setState(() => selectedGender = 'Female');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectionCard({
    required IconData icon,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: const Color(0xFF2E7D32).withOpacity(0.2),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2E7D32).withOpacity(0.2) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: const Color(0xFF2E7D32).withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1,
              )
            ] : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.shade600,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                text,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? const Color(0xFF2E7D32) : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Icon(
                    Icons.check_circle,
                    color: const Color(0xFF2E7D32),
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyMeasurementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Body Measurements",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  prefixIcon: const Icon(Icons.monitor_weight_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorText: weightError,
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                  ),
                  suffixIcon: weightController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            weightController.clear();
                            weightError = null;
                          });
                        },
                      )
                    : null,
                ),
                onChanged: (_) => setState(() => weightError = null),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Height (cm)',
                  prefixIcon: const Icon(Icons.height),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorText: heightError,
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                  ),
                  suffixIcon: heightController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            heightController.clear();
                            heightError = null;
                          });
                        },
                      )
                    : null,
                ),
                onChanged: (_) => setState(() => heightError = null),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAgeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Age", 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: ageController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Enter your age",
            prefixIcon: const Icon(Icons.calendar_today),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            errorText: ageError,
            filled: true,
            fillColor: Colors.grey.shade50,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
            ),
            suffixIcon: ageController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      ageController.clear();
                      ageError = null;
                    });
                  },
                )
              : null,
          ),
          onChanged: (_) => setState(() => ageError = null),
        ),
      ],
    );
  }

  Widget _buildActivityLevelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Activity Level",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildActivityTile(
              'Sedentary', 
              'Little or no exercise', 
              Icons.weekend,
              selectedActivityLevel == 'Sedentary',
              () => setState(() => selectedActivityLevel = 'Sedentary'),
            ),
            _buildActivityTile(
              'Lightly Active', 
              'Light exercise 1-3 days/week', 
              Icons.directions_walk,
              selectedActivityLevel == 'Lightly_active',
              () => setState(() => selectedActivityLevel = 'Lightly_active'),
            ),
            _buildActivityTile(
              'Moderately Active', 
              'Moderate exercise 3-5 days/week', 
              Icons.directions_run,
              selectedActivityLevel == 'Moderately_active',
              () => setState(() => selectedActivityLevel = 'Moderately_active'),
            ),
            _buildActivityTile(
              'Very Active', 
              'Hard exercise 6-7 days/week', 
              Icons.fitness_center,
              selectedActivityLevel == 'Very_active',
              () => setState(() => selectedActivityLevel = 'Very_active'),
            ),
            _buildActivityTile(
              'Extra Active', 
              'Hard daily exercise & physical job', 
              Icons.sports,
              selectedActivityLevel == 'Extra_active',
              () => setState(() => selectedActivityLevel = 'Extra_active'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityTile(String title, String subtitle, IconData icon, bool selected, VoidCallback onTap) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        elevation: selected ? 3 : 1,
        borderRadius: BorderRadius.circular(12),
        color: selected ? const Color(0xFF2E7D32).withOpacity(0.1) : Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: const Color(0xFF2E7D32).withOpacity(0.2),
          highlightColor: const Color(0xFF2E7D32).withOpacity(0.1),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? const Color(0xFF2E7D32) : Colors.transparent,
                width: 2,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected 
                    ? const Color(0xFF2E7D32).withOpacity(0.2) 
                    : Colors.grey.shade200,
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  icon,
                  color: selected ? const Color(0xFF2E7D32) : Colors.grey.shade700,
                  size: 24,
                ),
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  color: selected ? const Color(0xFF2E7D32) : Colors.black87,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: TextStyle(
                  color: selected ? const Color(0xFF2E7D32).withOpacity(0.7) : Colors.grey.shade600,
                ),
              ),
              trailing: selected 
                ? const Icon(Icons.check_circle, color: Color(0xFF2E7D32)) 
                : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyShapeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Desired Body Shape",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.6, // Increased aspect ratio to provide more height
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildBodyShapeCard(
              'Muscular',
              'Build muscle mass',
              'assets/images/muscular.png',
              selectedBodyShape == 'Muscular',
            ),
            _buildBodyShapeCard(
              'Lean',
              'Low body fat',
              'assets/images/lean.png',
              selectedBodyShape == 'Lean',
            ),
            _buildBodyShapeCard(
              'Athletic',
              'Balance of muscle and definition',
              'assets/images/athletic.png',
              selectedBodyShape == 'Athletic',
            ),
            _buildBodyShapeCard(
              'Weight_loss',
              'Focus on losing weight',
              'assets/images/weight_loss.png',
              selectedBodyShape == 'Weight_loss',
            ),
            _buildBodyShapeCard(
              'Maintain',
              'Maintain current physique',
              'assets/images/maintain.png',
              selectedBodyShape == 'Maintain',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBodyShapeCard(String title, String description, String imagePath, bool selected) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            selectedBodyShape = title;
          });
          // Add haptic feedback
          HapticFeedback.lightImpact();
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: const Color(0xFF2E7D32).withOpacity(0.2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF2E7D32).withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? const Color(0xFF2E7D32) : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: selected ? [
              BoxShadow(
                color: const Color(0xFF2E7D32).withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1,
              )
            ] : null,
          ),
          padding: const EdgeInsets.all(8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 24, // Reduced size
                    color: selected ? const Color(0xFF2E7D32) : Colors.grey.shade600,
                  ),
                  const SizedBox(height: 4), // Reduced spacing
                  Text(
                    title.replaceAll('_', ' '),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13, // Smaller font size
                      color: selected ? const Color(0xFF2E7D32) : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Flexible(
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 11, // Smaller font size
                        color: selected ? const Color(0xFF2E7D32).withOpacity(0.8) : Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (selected)
                    Padding(
                      padding: const EdgeInsets.only(top: 2), // Reduced top padding
                      child: Icon(
                        Icons.check_circle,
                        color: const Color(0xFF2E7D32),
                        size: 14, // Smaller icon
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLanguageSection(),
            const Divider(height: 32),
            _buildFoodTypeSection(),
            const Divider(height: 32),
            _buildBodyMeasurementsSection(),
            const SizedBox(height: 24),
            _buildAgeSection(),
            const SizedBox(height: 24),
            _buildGenderSection(),
            const SizedBox(height: 24),
            _buildActivityLevelSection(),
            const SizedBox(height: 24),
            _buildBodyShapeSection(),
            const SizedBox(height: 32),
            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          shadowColor: const Color(0xFF2E7D32).withOpacity(0.5),
        ),
        onPressed: isSubmitting ? null : () {
          // Add haptic feedback
          HapticFeedback.mediumImpact();
          _validateAndProceed();
        },
        icon: isSubmitting 
            ? Container(
                width: 24,
                height: 24,
                padding: const EdgeInsets.all(2.0),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                )
              )
            : const Icon(Icons.navigate_next),
        label: Text(
          isSubmitting ? "Processing..." : "Continue",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _validateAndProceed() async {
    // Reset error messages
    setState(() {
      weightError = null;
      heightError = null;
      ageError = null;
    });

    // Validate weight
    if (weightController.text.isEmpty) {
      setState(() => weightError = "Weight is required");
      return;
    } else if (double.tryParse(weightController.text) == null) {
      setState(() => weightError = "Enter a valid number");
      return;
    }

    // Validate height
    if (heightController.text.isEmpty) {
      setState(() => heightError = "Height is required");
      return;
    } else if (double.tryParse(heightController.text) == null) {
      setState(() => heightError = "Enter a valid number");
      return;
    } else if (double.parse(heightController.text) <= 100) {
      setState(() => heightError = "Height must be > 100 cm");
      return;
    }

    // Validate age
    if (ageController.text.isEmpty) {
      setState(() => ageError = "Age is required");
      return;
    } else if (int.tryParse(ageController.text) == null) {
      setState(() => ageError = "Enter a valid age");
      return;
    }

    // Set loading state
    setState(() {
      isSubmitting = true;
    });

    try {
      // Create user info request
      final userInfoRequest = UserInfoRequest(
        language: selectedLanguage ?? 'English',
        foodType: selectedFoodType ?? 'Mixed',
        weight: double.parse(weightController.text),
        height: double.parse(heightController.text),
        age: int.parse(ageController.text),
        gender: selectedGender ?? 'Male',
        activityLevel: selectedActivityLevel ?? 'Sedentary',
        bodyShapeGoal: selectedBodyShape ?? 'Weight_loss',
      );
      
      // Call API to set user info
      final success = await nutritionController.setUserInfo(userInfoRequest);
      
      // Only update UI if still mounted
      if (!mounted) return;
      
      setState(() {
        isSubmitting = false;
      });
      
      if (success) {
        // Show success animation
        Get.snackbar(
          'Success', 
          'Your information has been saved!',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
          duration: const Duration(seconds: 2),
        );
        
        // Wait for the snackbar to complete before navigating
        await Future.delayed(const Duration(seconds: 2));
        
        // Check mounted again before navigation
        if (!mounted) return;
        
        // Navigate to home page using offAll to completely remove previous screens
        Get.offAll(() => HomeScreen(), transition: Transition.rightToLeft);
      } else {
        // Show error
        Get.snackbar(
          'Error', 
          nutritionController.errorMessage.value,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        isSubmitting = false;
      });
      
      Get.snackbar(
        'Error', 
        'Failed to save information: $e',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }
  }

  @override
  void dispose() {
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }
}
