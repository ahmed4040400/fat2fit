import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart'; // Add Lottie import
import '../controllers/nutrition_controller.dart';
import '../models/detailed_meal_plan.dart';
import '../widgets/nutrition/loading_view.dart';
import '../widgets/nutrition/error_view.dart';
import '../widgets/nutrition/empty_state.dart';
import '../widgets/nutrition/meal_plan_view.dart';
import '../widgets/nutrition/rating_form.dart';
import '../widgets/nutrition/dialogs/plan_dialogs.dart';
// Make sure to import the new widgets
import '../widgets/nutrition/daily_nutrition_summary.dart';
import '../widgets/nutrition/meal_card.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({Key? key}) : super(key: key);

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> with TickerProviderStateMixin {
  final NutritionController nutritionController = Get.find<NutritionController>();
  late TabController _tabController;
  int _previousIndex = 0; // Track previous index to detect actual changes
  
  // For animations - initialize with default values instead of using late
  AnimationController? _animationController;
  AnimationController? _loopingAnimationController;
  AnimationController? _pageTransitionController;
  AnimationController? _pulseAnimationController;
  Animation<double>? _scaleAnimation;
  
  // New animation controllers for enhanced effects - initialize without late
  AnimationController? _tabSwitchAnimationController;
  AnimationController? _contentAppearController;
  Animation<double>? _fadeInAnimation;
  Animation<Offset>? _slideAnimation;
  
  // Animation flags to control Lottie animations
  bool _showSuccessAnimation = false;
  bool _showTransitionAnimation = false;
  bool _animationsInitialized = false;
  
  // Add a timeout flag to prevent infinite loading
  bool _loadingTimedOut = false;
  
  // Add a flag to track initial load
  bool _isInitialLoad = true;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    
    // Set initial selected day
    nutritionController.changeSelectedDay(nutritionController.weekdays[_tabController.index]);
    _previousIndex = _tabController.index;
    
    // Initialize all animations immediately
    _initializeAnimations();
    
    // Explicitly load the meal plan right away
    _loadMealPlanImmediately();
    
    // Simplified listener that more reliably detects both tap and swipe changes
    _tabController.addListener(_handleTabChange);
    
    // Listen to changes in selectedDay and update tab controller accordingly
    _setupObservers();
    
    // Add safety timeout to prevent infinite loading state
    _setupLoadingTimeout();
  }
  
  // Extract all Rx observers to a separate method for better organization
  void _setupObservers() {
    // Listen to changes in selectedDay and update tab controller accordingly
    ever(nutritionController.selectedDay, (String day) {
      if (!mounted) return;
      final index = nutritionController.weekdays.indexOf(day);
      if (index != -1 && index != _tabController.index) {
        _tabController.animateTo(index);
      }
    });
    
    // Listen to meal plan loading to trigger success animation
    ever(nutritionController.isLoading, (bool loading) {
      if (!mounted) return;
      if (!loading && nutritionController.detailedMealPlan.value != null) {
        _showSuccessAnimationBriefly();
      }
      
      // If loading started, reset the timeout flag
      if (loading) {
        _loadingTimedOut = false;
        _setupLoadingTimeout();
      }
      
      // Debug log
      debugPrint('Loading state changed: $loading');
    });
    
    // Add listener for detecting when data is loaded
    ever(nutritionController.detailedMealPlan, (_) {
      if (!mounted) return;
      if (_isInitialLoad && nutritionController.detailedMealPlan.value != null) {
        // Only run the content appear animation on first successful data load
        _contentAppearController?.forward(from: 0.0);
        _isInitialLoad = false;
      }
    });
  }
  
  // Extract animation initialization to a separate method
  void _initializeAnimations() {
    // Main animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Looping animation controller for continuous effects
    _loopingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    // Page transition animation controller
    _pageTransitionController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    // Pulse animation for highlights
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _pulseAnimationController!,
        curve: Curves.easeInOut,
      ),
    );
    
    // New animation controllers for enhanced effects
    _tabSwitchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _contentAppearController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _contentAppearController!,
        curve: Curves.easeIn,
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentAppearController!,
        curve: Curves.easeOutCubic,
      ),
    );
    
    // Add loops to pulse animation
    _pulseAnimationController!.repeat(reverse: true);
    
    // Start only animations that should run immediately
    _animationController!.forward();
    _pageTransitionController!.forward();
    // Don't auto-start content appear animation: _contentAppearController!.forward();
    
    // Mark animations as initialized
    _animationsInitialized = true;
  }
  
  // Method to briefly show success animation
  void _showSuccessAnimationBriefly() {
    if (!mounted) return;
    setState(() => _showSuccessAnimation = true);
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() => _showSuccessAnimation = false);
      }
    });
  }
  
  // New method to handle tab changes more reliably
  void _handleTabChange() {
    // Detect actual index changes, whether from tap or swipe
    if (_tabController.index != _previousIndex) {
      // Update the selected day
      _updateSelectedDay(_tabController.index);
      
      // Reset and start page transition animation
      _pageTransitionController?.reset();
      _pageTransitionController?.forward();
      
      // Reset tab switch animation
      _tabSwitchAnimationController?.reset();
      _tabSwitchAnimationController?.forward();
      
      // Show brief transition animation
      if (mounted) {
        setState(() => _showTransitionAnimation = true);
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) setState(() => _showTransitionAnimation = false);
        });
      }
      
      // Add haptic feedback
      HapticFeedback.selectionClick();
      
      // Update previous index
      _previousIndex = _tabController.index;
    }
  }
  
  void _updateSelectedDay(int index) {
    nutritionController.changeSelectedDay(nutritionController.weekdays[index]);
    
    // Don't reset content appear animation when changing days
    // Instead, use page transition animation which is already being handled
    
    // Optional: If you want a subtle animation when changing days, use this:
    if (!_isInitialLoad) {
      // Create a more subtle transition for day changes
      _pageTransitionController?.reset();
      _pageTransitionController?.forward();
    }
  }
  
  // Add method to setup a safety timeout for loading state
  void _setupLoadingTimeout() {
    // Clear any infinite loading after 15 seconds
    Future.delayed(const Duration(seconds: 15), () {
      if (mounted && nutritionController.isLoading.value) {
        debugPrint('⚠️ Loading timeout occurred - forcing loading state to complete');
        setState(() => _loadingTimedOut = true);
        
        // Force loading to complete if it's hanging
        nutritionController.isLoading.value = false;
        
        // If there's no data, set an error message
        if (nutritionController.detailedMealPlan.value == null && 
            nutritionController.errorMessage.value.isEmpty) {
          nutritionController.errorMessage.value = 
              'Loading timed out. Please try again.';
        }
      }
    });
  }
  
  // Add a new method to explicitly load the meal plan
  void _loadMealPlanImmediately() {
    debugPrint('📋 Explicitly loading meal plan from Firestore on screen open');
    
    // If we have a session ID, try to load from Firestore directly
    if (nutritionController.sessionId.value.isNotEmpty) {
      nutritionController.loadMealPlanFromFirestore();
    } else {
      // Otherwise, load session ID first (which will then load the meal plan)
      nutritionController.loadSessionId();
    }
  }
  
  @override
  void dispose() {
    // Clear all observers to prevent memory leaks
    _tabController.removeListener(_handleTabChange); // Remove listener
    _tabController.dispose();
    _animationController?.dispose();
    _loopingAnimationController?.dispose();
    _pageTransitionController?.dispose();
    _pulseAnimationController?.dispose();
    _tabSwitchAnimationController?.dispose();
    _contentAppearController?.dispose();
    
    // Important: Cancel any worker subscriptions from GetX
    Get.delete<NutritionController>(tag: 'nutrition_screen');
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Change to true for a more immersive feel
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // Background with animated gradient
          AnimatedBuilder(
            animation: _loopingAnimationController ?? const AlwaysStoppedAnimation(0),
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      const Color(0xFFF1F8E9).withOpacity(0.7 + (_loopingAnimationController?.value ?? 0) * 0.3),
                      const Color(0xFFE8F5E9).withOpacity(0.8),
                    ],
                    stops: [
                      0.0,
                      0.6 + (_loopingAnimationController?.value ?? 0) * 0.1,
                      1.0
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Subtle pattern overlay
          Opacity(
            opacity: 0.05,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://www.transparenttextures.com/patterns/food.png'),
                  repeat: ImageRepeat.repeat,
                ),
              ),
            ),
          ),
          
          // Main content
          Obx(() {
            // Add debug print to help track the issue
            debugPrint('Building nutrition screen: isLoading=${nutritionController.isLoading.value}, '
                'hasError=${nutritionController.errorMessage.value.isNotEmpty}, '
                'hasPlan=${nutritionController.detailedMealPlan.value != null}, '
                'showRating=${nutritionController.showRatingForm.value}');
            
            // If loading timed out, don't show the loading view
            if (nutritionController.isLoading.value && !_loadingTimedOut) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Lottie loading animation
                    Lottie.network(
                      'https://assets10.lottiefiles.com/packages/lf20_vxnelydc.json', // Food loading animation
                      width: 200,
                      height: 200,
                      // Add onLoaded callback to debug animation loading issues
                      onLoaded: (composition) {
                        debugPrint('Loading animation loaded successfully');
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Preparing your healthy meal plan...",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    
                    // Add a loading indicator to show progress
                    const SizedBox(height: 15),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                    ),
                  ],
                ),
              );
            }
            
            if (nutritionController.errorMessage.value.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Error animation
                    Lottie.network(
                      'https://assets6.lottiefiles.com/packages/lf20_iikbn1ww.json', // Error animation
                      width: 160,
                      height: 160,
                    ),
                    const SizedBox(height: 20),
                    ErrorView(
                      errorMessage: nutritionController.errorMessage.value,
                      onRetry: () {
                        nutritionController.errorMessage.value = '';
                        nutritionController.loadSessionId();
                      },
                    ),
                  ],
                ),
              );
            }
            
            if (nutritionController.showRatingForm.value) {
              // Make sure animation is available before using it
              if (!_animationsInitialized) return const Center(child: CircularProgressIndicator());
              
              return FadeTransition(
                opacity: _fadeInAnimation ?? const AlwaysStoppedAnimation(1.0),
                child: SlideTransition(
                  position: _slideAnimation ?? const AlwaysStoppedAnimation(Offset.zero),
                  child: RatingForm(
                    nutritionController: nutritionController,
                    animationController: _animationController!,
                  ),
                ),
              );
            }
            
            if (nutritionController.detailedMealPlan.value == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Empty state animation
                    Lottie.network(
                      'https://assets3.lottiefiles.com/private_files/lf30_ajzyv37m.json', // Cooking animation
                      width: 250,
                      height: 250,
                    ),
                    const SizedBox(height: 10),
                    EmptyState(
                      animationController: _animationController!,
                      onGoBack: () => Get.back(),
                    ),
                  ],
                ),
              );
            }
            
            // Make sure animation is available before using it
            if (!_animationsInitialized) return const Center(child: CircularProgressIndicator());
            
            return FadeTransition(
              opacity: _fadeInAnimation ?? const AlwaysStoppedAnimation(1.0),
              child: SlideTransition(
                position: _slideAnimation ?? const AlwaysStoppedAnimation(Offset.zero),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    // Use a different animation for day changes
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: MealPlanView(
                    key: ValueKey<String>(nutritionController.selectedDay.value),
                    nutritionController: nutritionController,
                    tabController: _tabController,
                    animationController: _animationController!,
                    loopingAnimationController: _loopingAnimationController!,
                    pageTransitionController: _pageTransitionController!,
                  ),
                ),
              ),
            );
          }),
          
          // Success animation overlay that shows briefly when plan is loaded
          if (_showSuccessAnimation)
            Center(
              child: Lottie.network(
                'https://assets2.lottiefiles.com/packages/lf20_jbrw3hcz.json', // Success checkmark
                width: 200,
                height: 200,
                repeat: false,
              ),
            ),
          
          // Day transition animation
          if (_showTransitionAnimation)
            Positioned(
              right: 10,
              top: MediaQuery.of(context).size.height / 3,
              child: Lottie.network(
                'https://assets7.lottiefiles.com/packages/lf20_obhph3sh.json', // Swipe animation
                width: 80,
                height: 80,
              ),
            ),
        ],
      ),
      floatingActionButton: Obx(() {
        // Only show the FAB when we have a session ID and not showing ratings or loading
        if (nutritionController.sessionId.value.isNotEmpty && 
            !nutritionController.isLoading.value && 
            !nutritionController.showRatingForm.value &&
            _animationsInitialized) {
          return ScaleTransition(
            scale: _scaleAnimation ?? const AlwaysStoppedAnimation(1.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                HapticFeedback.mediumImpact();
                // Changed from showRegeneratePlanDialog to showGeneratePlanDialog
                showGeneratePlanDialog(context, nutritionController, () {
                  _animationController?.reset();
                  _animationController?.forward();
                  _pageTransitionController?.reset();
                  _pageTransitionController?.forward();
                  _showSuccessAnimationBriefly();
                });
              },
              label: Row(
                children: [
                  // Small Lottie animation inside FAB
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Lottie.network(
                      'https://assets5.lottiefiles.com/packages/lf20_n2m0isqh.json', // Food icon animation
                      fit: BoxFit.contain,
                      
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Changed text back to 'Generate Plan' from 'Regenerate Plan'
                  const Text('Generate Plan'),
                ],
              ),
              icon: const Icon(Icons.restaurant_menu), // Changed icon back to restaurant_menu from refresh
              backgroundColor: const Color(0xFF2E7D32),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
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
          // Small Lottie animation beside the title
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Lottie.network(
              'https://assets9.lottiefiles.com/packages/lf20_ysas4vcp.json', // Healthy food icon
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'My Nutrition Plan', 
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          tooltip: 'Generate Plan',
          onPressed: () => showGeneratePlanDialog(context, nutritionController, () { 
            _animationController?.reset();
            _animationController?.forward();
            _pageTransitionController?.reset();
            _pageTransitionController?.forward();
            _showSuccessAnimationBriefly();
          }),
        ),
      ],
    );
  }
}
