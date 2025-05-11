import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../controllers/nutrition_controller.dart';
import '../models/nutrition_models.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final nutritionController = Get.find<NutritionController>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Form controllers
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  
  // Dropdown values
  String? selectedLanguage;
  String? selectedFoodType;
  String? selectedGender;
  String? selectedActivityLevel;
  String? selectedBodyShape;
  
  // Loading states
  bool isLoading = true;
  bool isSaving = false;
  String errorMessage = '';
  
  // Editable state
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    
    try {
      // Changed from getUserInfoFromFirestore to getUserInfo
      final userData = await nutritionController.getUserInfo();
      if (userData != null) {
        // Populate form fields
        setState(() {
          weightController.text = userData['weight']?.toString() ?? '';
          heightController.text = userData['height']?.toString() ?? '';
          ageController.text = userData['age']?.toString() ?? '';
          
          selectedLanguage = userData['language'] ?? 'English';
          selectedFoodType = userData['foodType'] ?? 'Mixed';
          selectedGender = userData['gender'] ?? 'Male';
          selectedActivityLevel = userData['activityLevel'] ?? 'Sedentary';
          selectedBodyShape = userData['bodyShapeGoal'] ?? 'Weight_loss';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load profile data: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  
  Future<void> _saveUserData() async {
    if (!_validateForm()) return;
    
    setState(() {
      isSaving = true;
      errorMessage = '';
    });
    
    try {
      final userInfo = UserInfoRequest(
        language: selectedLanguage ?? 'English',
        foodType: selectedFoodType ?? 'Mixed',
        weight: double.parse(weightController.text),
        height: double.parse(heightController.text),
        age: int.parse(ageController.text),
        gender: selectedGender ?? 'Male',
        activityLevel: selectedActivityLevel ?? 'Sedentary',
        bodyShapeGoal: selectedBodyShape ?? 'Weight_loss',
      );
      
      // Changed from saveUserInfoToFirestore to saveUserInfo
      final success = await nutritionController.setUserInfo(userInfo);
      
      // Check if still mounted before updating UI
      if (!mounted) return;
      
      if (success) {
        // Show success message
        Get.snackbar(
          'Success', 
          'Your profile has been updated',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
          duration: const Duration(seconds: 2),
        );
        
        // Exit edit mode
        setState(() {
          isEditing = false;
          isSaving = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to update profile';
          isSaving = false;
        });
      }
    } catch (e) {
      // Check if still mounted before updating UI
      if (!mounted) return;
      
      setState(() {
        errorMessage = 'Error updating profile: $e';
        isSaving = false;
      });
    }
  }
  
  bool _validateForm() {
    // Validate weight
    if (weightController.text.isEmpty) {
      _showError('Weight is required');
      return false;
    }
    if (double.tryParse(weightController.text) == null) {
      _showError('Enter a valid weight');
      return false;
    }
    
    // Validate height
    if (heightController.text.isEmpty) {
      _showError('Height is required');
      return false;
    }
    if (double.tryParse(heightController.text) == null) {
      _showError('Enter a valid height');
      return false;
    }
    
    // Validate age
    if (ageController.text.isEmpty) {
      _showError('Age is required');
      return false;
    }
    if (int.tryParse(ageController.text) == null) {
      _showError('Enter a valid age');
      return false;
    }
    
    return true;
  }
  
  void _showError(String message) {
    Get.snackbar(
      'Error', 
      message,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade800,
    );
  }

  // Add a new method to handle logout
  Future<void> _logout() async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );
      
      // Sign out the user
      await _auth.signOut();
      
      // Close the loading indicator
      Get.back();
      
      // Navigate to login screen
      Get.offAllNamed('/login');
      
      // Show success message
      Get.snackbar(
        'Success', 
        'You have been logged out',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      // Close loading indicator if showing
      if (Get.isDialogOpen == true) Get.back();
      
      // Show error message
      Get.snackbar(
        'Error', 
        'Failed to logout: $e',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: isLoading 
        ? _buildLoadingView() 
        : errorMessage.isNotEmpty 
          ? _buildErrorView() 
          : _buildProfileView(),
      floatingActionButton: isEditing ? FloatingActionButton.extended(
        onPressed: isSaving ? null : _saveUserData,
        backgroundColor: const Color(0xFF2E7D32),
        icon: isSaving 
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ) 
          : const Icon(Icons.save),
        label: Text(isSaving ? 'Saving...' : 'Save Changes'),
      ) : null,
    );
  }
  
  PreferredSizeWidget _buildAppBar() {
    final email = _auth.currentUser?.email ?? 'User';
    String emailInitial = (email.isNotEmpty) ? email[0].toUpperCase() : 'U';
    
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade800, Colors.green.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
      ),
      title: Row(
        children: [
          // User avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              color: Colors.green.shade300,
            ),
            child: Center(
              child: Text(
                emailInitial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'My Profile', 
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        // Add logout button to app bar
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          tooltip: 'Logout',
          onPressed: _logout,
        ),
        if (!isEditing)
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: 'Edit Profile',
            onPressed: () {
              setState(() {
                isEditing = true;
              });
            },
          )
        else
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.white),
            tooltip: 'Cancel',
            onPressed: () {
              // Reload data to discard changes
              _loadUserData();
              setState(() {
                isEditing = false;
              });
            },
          ),
      ],
    );
  }
  
  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF2E7D32)),
          SizedBox(height: 16),
          Text('Loading profile data...')
        ],
      ),
    );
  }
  
  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(errorMessage, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadUserData,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProfileView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          _buildPersonalInfoSection(),
          const SizedBox(height: 24),
          _buildPhysicalInfoSection(),
          const SizedBox(height: 24),
          _buildPreferencesSection(),
          // Add bottom padding for the FAB
          SizedBox(height: isEditing ? 80 : 24),
        ],
      ),
    );
  }
  
  Widget _buildProfileHeader() {
    final email = _auth.currentUser?.email ?? 'User';
    final displayName = _auth.currentUser?.displayName;
    final photoUrl = _auth.currentUser?.photoURL;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile picture with edit capability
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null 
                      ? Icon(Icons.person, size: 50, color: Colors.grey.shade700) 
                      : null,
                ),
                if (isEditing)
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFF2E7D32),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                      onPressed: () {
                        // Implement photo update logic
                        Get.snackbar('Coming Soon', 'Photo update feature coming soon!',
                            backgroundColor: Colors.blue.shade100);
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              displayName ?? 'User Profile',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            // Quick stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('Weight', '${weightController.text} kg'),
                _buildStatItem('Height', '${heightController.text} cm'),
                _buildStatItem('Age', ageController.text),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
      ],
    );
  }
  
  Widget _buildPersonalInfoSection() {
    return _buildSectionCard(
      'Personal Information',
      Icons.person,
      Column(
        children: [
          // Age field
          _buildTextField(
            label: 'Age',
            controller: ageController,
            icon: Icons.cake,
            keyboardType: TextInputType.number,
            enabled: isEditing,
          ),
          const SizedBox(height: 16),
          // Gender dropdown
          _buildDropdown(
            label: 'Gender',
            value: selectedGender,
            items: const ['Male', 'Female', 'Other'],
            icon: Icons.wc,
            onChanged: isEditing ? (value) {
              setState(() {
                selectedGender = value;
              });
            } : null,
          ),
          const SizedBox(height: 16),
          // Language dropdown
          _buildDropdown(
            label: 'Preferred Language',
            value: selectedLanguage,
            items: const ['English', 'Arabic'],
            icon: Icons.language,
            onChanged: isEditing ? (value) {
              setState(() {
                selectedLanguage = value;
              });
            } : null,
          ),
        ],
      ),
    );
  }
  
  Widget _buildPhysicalInfoSection() {
    return _buildSectionCard(
      'Body Measurements',
      Icons.accessibility_new,
      Column(
        children: [
          // Weight field
          _buildTextField(
            label: 'Weight (kg)',
            controller: weightController,
            icon: Icons.monitor_weight_outlined,
            keyboardType: TextInputType.number,
            enabled: isEditing,
          ),
          const SizedBox(height: 16),
          // Height field
          _buildTextField(
            label: 'Height (cm)',
            controller: heightController,
            icon: Icons.height,
            keyboardType: TextInputType.number,
            enabled: isEditing,
          ),
        ],
      ),
    );
  }
  
  Widget _buildPreferencesSection() {
    return _buildSectionCard(
      'Fitness Preferences',
      Icons.fitness_center,
      Column(
        children: [
          // Activity Level dropdown
          _buildDropdown(
            label: 'Activity Level',
            value: selectedActivityLevel,
            items: const [
              'Sedentary', 
              'Lightly_active', 
              'Moderately_active', 
              'Very_active', 
              'Extra_active'
            ],
            icon: Icons.directions_run,
            onChanged: isEditing ? (value) {
              setState(() {
                selectedActivityLevel = value;
              });
            } : null,
            displayNameMap: {
              'Lightly_active': 'Lightly Active',
              'Moderately_active': 'Moderately Active',
              'Very_active': 'Very Active',
              'Extra_active': 'Extra Active',
            },
          ),
          const SizedBox(height: 16),
          // Body Shape Goal dropdown
          _buildDropdown(
            label: 'Body Shape Goal',
            value: selectedBodyShape,
            items: const ['Muscular', 'Lean', 'Athletic', 'Weight_loss', 'Maintain'],
            icon: Icons.accessibility,
            onChanged: isEditing ? (value) {
              setState(() {
                selectedBodyShape = value;
              });
            } : null,
            displayNameMap: {
              'Weight_loss': 'Weight Loss',
            },
          ),
          const SizedBox(height: 16),
          // Food Type dropdown
          _buildDropdown(
            label: 'Food Preference',
            value: selectedFoodType,
            items: const ['Egyptian', 'American', 'Mixed'],
            icon: Icons.restaurant_menu,
            onChanged: isEditing ? (value) {
              setState(() {
                selectedFoodType = value;
              });
            } : null,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionCard(String title, IconData icon, Widget content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(
              children: [
                Icon(icon, color: const Color(0xFF2E7D32)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            // Section content
            content,
          ],
        ),
      ),
    );
  }
  
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: enabled ? Colors.transparent : Colors.grey.shade100,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
        enabled: enabled,
      ),
      keyboardType: keyboardType,
      style: TextStyle(
        color: enabled ? Colors.black : Colors.grey.shade700,
      ),
    );
  }
  
  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    Function(String?)? onChanged,
    Map<String, String>? displayNameMap,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: onChanged != null ? Colors.transparent : Colors.grey.shade100,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
        enabled: onChanged != null,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          isExpanded: true,
          onChanged: onChanged,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                displayNameMap?[item] ?? item.replaceAll('_', ' '), // Format display name
                style: TextStyle(
                  color: onChanged != null ? Colors.black : Colors.grey.shade700,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    ageController.dispose();
    super.dispose();
  }
}
