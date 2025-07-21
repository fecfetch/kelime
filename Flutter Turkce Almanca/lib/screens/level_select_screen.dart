import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../models/game_level.dart';
import 'game_screen.dart';

class LevelSelectScreen extends StatefulWidget {
  final int world;
  
  const LevelSelectScreen({super.key, required this.world});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  int selectedSubWorld = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dünya ${widget.world + 1} - Seviye Seçin'),
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
          child: Column(
            children: [
              // Sub-world tabs
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: WorldData.numSubWorlds,
                  itemBuilder: (context, subWorldIndex) {
                    return _buildSubWorldTab(context, subWorldIndex);
                  },
                ),
              ),
              
              // Levels grid
              Expanded(
                child: Consumer<ProgressProvider>(
                  builder: (context, progress, child) {
                    return _buildLevelsGrid(context, progress, selectedSubWorld);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubWorldTab(BuildContext context, int subWorldIndex) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedSubWorld = subWorldIndex;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedSubWorld == subWorldIndex 
              ? const Color(0xFF4A90E2) 
              : Colors.white.withOpacity(0.9),
          foregroundColor: selectedSubWorld == subWorldIndex 
              ? Colors.white 
              : const Color(0xFF4A90E2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text('Alt ${subWorldIndex + 1}'),
      ),
    );
  }

  Widget _buildLevelsGrid(BuildContext context, ProgressProvider progress, int subWorld) {
    final numLevels = WorldData.getNumLevels(widget.world, subWorld);
    
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: numLevels,
      itemBuilder: (context, index) {
        final isUnlocked = progress.isLevelUnlocked(widget.world, subWorld, index);
        return _buildLevelButton(context, index, isUnlocked, subWorld);
      },
    );
  }

  Widget _buildLevelButton(BuildContext context, int levelIndex, bool isUnlocked, int subWorld) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: isUnlocked ? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameScreen(
                world: widget.world,
                subWorld: subWorld,
                level: levelIndex,
              ),
            ),
          );
        } : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isUnlocked 
                ? [const Color(0xFF4CAF50), const Color(0xFF8BC34A)]
                : [Colors.grey.shade400, Colors.grey.shade600],
            ),
          ),
          child: Center(
            child: isUnlocked 
              ? Text(
                  '${levelIndex + 1}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              : const Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 24,
                ),
          ),
        ),
      ),
    );
  }
}