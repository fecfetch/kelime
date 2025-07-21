import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import 'level_select_screen.dart';

class WorldSelectScreen extends StatelessWidget {
  const WorldSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dünya Seçin'),
        backgroundColor: const Color(0xFF4A90E2),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A90E2),
              Color(0xFF7B68EE),
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<ProgressProvider>(
            builder: (context, progress, child) {
              return GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.2,
                ),
                itemCount: 7, // 7 worlds (0-6)
                itemBuilder: (context, index) {
                  // All worlds are unlocked so users can choose their difficulty level
                  const isUnlocked = true;
                  return _buildWorldCard(context, index, isUnlocked);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWorldCard(BuildContext context, int worldIndex, bool isUnlocked) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: isUnlocked ? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LevelSelectScreen(world: worldIndex),
            ),
          );
        } : null,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isUnlocked 
                ? _getWorldColors(worldIndex)
                : [Colors.grey.shade400, Colors.grey.shade600],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isUnlocked ? _getWorldIcon(worldIndex) : Icons.lock,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                'Dünya ${worldIndex + 1}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getWorldName(worldIndex),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              if (!isUnlocked) ...[
                const SizedBox(height: 8),
                const Icon(
                  Icons.lock,
                  size: 20,
                  color: Colors.white70,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _getWorldColors(int worldIndex) {
    const worldColors = [
      [Color(0xFF4CAF50), Color(0xFF8BC34A)], // Green
      [Color(0xFF2196F3), Color(0xFF03DAC6)], // Blue
      [Color(0xFFFF9800), Color(0xFFFFEB3B)], // Orange
      [Color(0xFF9C27B0), Color(0xFFE91E63)], // Purple
      [Color(0xFFF44336), Color(0xFFFF5722)], // Red
      [Color(0xFF607D8B), Color(0xFF9E9E9E)], // Blue Grey
      [Color(0xFF795548), Color(0xFFBCAAA4)], // Brown
    ];
    return worldColors[worldIndex % worldColors.length];
  }

  IconData _getWorldIcon(int worldIndex) {
    const worldIcons = [
      Icons.home,
      Icons.nature,
      Icons.local_fire_department,
      Icons.water_drop,
      Icons.bolt,
      Icons.ac_unit,
      Icons.star,
    ];
    return worldIcons[worldIndex % worldIcons.length];
  }

  String _getWorldName(int worldIndex) {
    const worldNames = [
      'Başlangıç - A1',
      'Temel - A2', 
      'Orta Alt - B1',
      'Orta - B2',
      'İleri Alt - C1',
      'İleri - C2',
      'Karışık - Tüm Seviyeler',
    ];
    return worldNames[worldIndex % worldNames.length];
  }
}