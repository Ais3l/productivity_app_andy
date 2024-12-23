import 'package:flutter/material.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Progress',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),

              // Today's Stats Card
              _buildStatsCard(
                'Today\'s Stats',
                [
                  _buildStatItem(Icons.timer, 'Focus Time', '2h 30m'),
                  _buildStatItem(Icons.nature, 'Trees Planted', '3'),
                  _buildStatItem(Icons.task_alt, 'Tasks Completed', '5'),
                ],
              ),

              const SizedBox(height: 20),

              // Weekly Overview Card
              _buildStatsCard(
                'Weekly Overview',
                [
                  _buildStatItem(Icons.timer, 'Total Focus Time', '12h 45m'),
                  _buildStatItem(Icons.nature, 'Total Trees', '15'),
                  _buildStatItem(
                      Icons.trending_up, 'Productivity Score', '85%'),
                ],
              ),

              const SizedBox(height: 20),

              // Achievements Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Achievements',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildAchievementItem(
                        'Early Bird',
                        'Completed 5 tasks before noon',
                        Icons.wb_sunny,
                        true,
                      ),
                      _buildAchievementItem(
                        'Forest Guardian',
                        'Planted 10 trees',
                        Icons.park,
                        true,
                      ),
                      _buildAchievementItem(
                        'Focus Master',
                        'Maintained focus for 2 hours straight',
                        Icons.psychology,
                        false,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(
      String title, String description, IconData icon, bool achieved) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: achieved ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (achieved)
            const Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
        ],
      ),
    );
  }
}
