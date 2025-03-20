import 'package:flutter/material.dart';
import '../widgets/task_item.dart';
import '../widgets/activity_card.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'Hi Ahmed',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                // Handle menu action
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildTasksSection(context),
              const SizedBox(height: 16),
              _buildActivitySection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTasksSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            children: [
              Expanded(
                child: Text(
                  "Today's tasks",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ),
              const Text('🐝', style: TextStyle(fontSize: 24)),
            ],
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Starting workout session...')),
              );
            },
            splashColor: Colors.green.withOpacity(0.1),
            highlightColor: Colors.green.withOpacity(0.05),
            child: const TaskItem(
              title: 'Start your workout today',
              imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_Zp1Tjwlc7TfjcwLXXuWHinZwr_FnaT2qOQ&s',
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tracking snacks...')),
              );
            },
            splashColor: Colors.green.withOpacity(0.1),
            highlightColor: Colors.green.withOpacity(0.05),
            child: const TaskItem(
              title: 'Number of snacks today',
              imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_Zp1Tjwlc7TfjcwLXXuWHinZwr_FnaT2qOQ&s',
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening competition details...')),
              );
            },
            splashColor: Colors.green.withOpacity(0.1),
            highlightColor: Colors.green.withOpacity(0.05),
            child: const TaskItem(
              title: 'Follow the competition',
              imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_Zp1Tjwlc7TfjcwLXXuWHinZwr_FnaT2qOQ&s',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            'Follow your activity',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening water tracking...')),
                    );
                  },
                  splashColor: Colors.green.withOpacity(0.1),
                  highlightColor: Colors.green.withOpacity(0.05),
                  child: ActivityCard(label: 'Water', icon: Icons.local_drink),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening step counter...')),
                    );
                  },
                  splashColor: Colors.green.withOpacity(0.1),
                  highlightColor: Colors.green.withOpacity(0.05),
                  child: ActivityCard(
                    label: 'Steps',
                    icon: Icons.directions_walk,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
