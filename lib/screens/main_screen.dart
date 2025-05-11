import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/task_item.dart';
import '../widgets/activity_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  
  // Using more reliable Lottie URLs and adding fallbacks
  final Map<String, String> _lottieUrls = {
    'fitness': 'https://assets8.lottiefiles.com/packages/lf20_aKRYl2.json',
    // Replace with a more reliable browse animation
    'browse': 'https://assets9.lottiefiles.com/packages/lf20_qp1q7mct.json', 
    'water': 'https://assets1.lottiefiles.com/packages/lf20_n4rbbuyk.json',
    'cardio': 'https://assets10.lottiefiles.com/packages/lf20_2scSKA.json',
    'nutrition': 'https://assets4.lottiefiles.com/packages/lf20_3s8p3miv.json',
    'recovery': 'https://assets8.lottiefiles.com/packages/lf20_FDWMMy.json',
  };
  
  // Add reliable image URLs with fallbacks
  final Map<String, String> _imageUrls = {
    'bench_press': 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
    'nutrition': 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
    // Replace with a more reliable stretching image URL
    'stretching': 'https://images.unsplash.com/photo-1575052814086-f385e2e2ad1b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60',
  };
  
  // Update user-related information to be more generic and Firebase-ready
  final Map<String, dynamic> _userData = {
    'level': 'Intermediate',
    'progress': 0.75,
    'streakDays': 8,
    'email': 'user@example.com', // Placeholder - will be replaced with Firebase Auth
  };
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildUserFocusedAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFocusAreas(),
              const SizedBox(height: 20),
              _buildDailyAdvice(context),
              const SizedBox(height: 20),
              _buildAdviceCategories(context),
              const SizedBox(height: 20),
              _buildQuickTips(context),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildUserFocusedAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.green,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade800, Colors.green.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Row(
        children: [
          _buildUserAvatar(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Hi there!', // Generic greeting instead of name
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _userData['level'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _userData['progress'],
                          minHeight: 5,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: Colors.amber,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${_userData["streakDays"]} day streak!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined, color: Colors.white),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications coming soon!')),
            );
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$value coming soon!')),
            );
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'Edit Profile',
              child: ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Edit Profile'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem<String>(
              value: 'Settings',
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem<String>(
              value: 'Help & Support',
              child: ListTile(
                leading: Icon(Icons.help),
                title: Text('Help & Support'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserAvatar() {
    // Get first letter of email with proper null handling
    String? email = _userData['email'] as String?;
    String emailInitial = (email != null && email.isNotEmpty) 
        ? email[0].toUpperCase() 
        : 'U'; // Default to 'U' for User if email is null or empty
    
    // When implementing Firebase Auth, replace with:
    // String emailInitial = FirebaseAuth.instance.currentUser?.email?.isNotEmpty == true
    //     ? FirebaseAuth.instance.currentUser!.email![0].toUpperCase()
    //     : 'U';

    return Container(
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
    );
  }

  Widget _buildFocusAreas() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      )),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade700, Colors.green.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Focus Areas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFocusItem('Strength', 'Primary', constraints.maxWidth / 3),
                          _buildFocusItem('Nutrition', 'Secondary', constraints.maxWidth / 3),
                          _buildFocusItem('Recovery', 'Ongoing', constraints.maxWidth / 3),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 80,
                child: _buildLottieAnimation('fitness', fit: BoxFit.contain),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build Lottie animations with error handling
  Widget _buildLottieAnimation(String key, {BoxFit fit = BoxFit.contain}) {
    return Lottie.network(
      _lottieUrls[key] ?? 'https://assets8.lottiefiles.com/packages/lf20_aKRYl2.json',
      fit: fit,
      frameRate: FrameRate.max,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          _getLottieFallbackIcon(key),
          color: Colors.white,
          size: 40,
        );
      },
    );
  }
  
  // Get fallback icon for when Lottie animations fail
  IconData _getLottieFallbackIcon(String key) {
    switch (key) {
      case 'fitness':
        return Icons.fitness_center;
      case 'browse':
        return Icons.menu_book;
      case 'water':
        return Icons.water_drop;
      case 'cardio':
        return Icons.directions_run;
      case 'nutrition':
        return Icons.fastfood;
      case 'recovery':
        return Icons.nightlight_round;
      default:
        return Icons.star;
    }
  }

  Widget _buildFocusItem(String label, String value, double width) {
    return SizedBox(
      width: width - 10, // Subtract some padding to prevent overflow
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDailyAdvice(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Today's Advice",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Personalized',
                    style: TextStyle(
                      color: Colors.green[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening chest workout tips...')),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: TaskItem(
                title: 'Proper Form: How to Perfect Your Bench Press',
                imageUrl: _imageUrls['bench_press']!,
                fallbackIcon: Icons.fitness_center,
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening nutrition advice...')),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: TaskItem(
                title: 'Post-Workout Meal: What to Eat for Maximum Recovery',
                imageUrl: _imageUrls['nutrition']!,
                fallbackIcon: Icons.restaurant,
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening stretching guide...')),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: TaskItem(
                title: '5 Essential Stretches to Improve Your Flexibility',
                imageUrl: _imageUrls['stretching']!,
                fallbackIcon: Icons.accessibility_new,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdviceCategories(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.5, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 1.0, curve: Curves.easeOut),
      )),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expert Advice Categories',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: _buildAdviceAnimation(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Browse our expert advice',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We have 120+ articles from certified trainers and nutritionists to help you achieve your goals',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildCategoryChip('Strength'),
                          _buildCategoryChip('Nutrition'),
                          _buildCategoryChip('Recovery'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Add a dedicated method for the advice section animation with enhanced fallback
  Widget _buildAdviceAnimation() {
    return Lottie.network(
      _lottieUrls['browse'] ?? 'https://assets9.lottiefiles.com/packages/lf20_qp1q7mct.json',
      fit: BoxFit.contain,
      frameRate: FrameRate.max,
      errorBuilder: (context, error, stackTrace) {
        // Use a static Container with icon if animation fails
        return Container(
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.menu_book,
              color: Colors.green[700],
              size: 40,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(String label) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label advice coming soon!')),
        );
      },
      child: Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: Colors.green.withOpacity(0.1),
        label: Text(
          label,
          style: TextStyle(
            color: Colors.green[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickTips(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Tips',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (constraints.maxWidth - 16) / 2;
                return Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: cardWidth,
                          child: InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Hydration tips coming soon!')),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: ActivityCard(
                              label: 'Hydration',
                              value: 'Tip',
                              icon: Icons.water_drop,
                              color: Colors.blue.shade400,
                              lottieUrl: _lottieUrls['water'],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: cardWidth,
                          child: InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Cardio tips coming soon!')),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: ActivityCard(
                              label: 'Cardio',
                              value: 'Tip',
                              icon: Icons.directions_run,
                              color: Colors.orange.shade400,
                              lottieUrl: _lottieUrls['cardio'],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        SizedBox(
                          width: cardWidth,
                          child: InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Nutrition tips coming soon!')),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: ActivityCard(
                              label: 'Protein',
                              value: 'Tip',
                              icon: Icons.fastfood,
                              color: Colors.red.shade400,
                              lottieUrl: _lottieUrls['nutrition'],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: cardWidth,
                          child: InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Recovery tips coming soon!')),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: ActivityCard(
                              label: 'Recovery',
                              value: 'Tip',
                              icon: Icons.nightlight_round,
                              color: Colors.purple.shade400,
                              lottieUrl: _lottieUrls['recovery'],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
