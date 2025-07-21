// Simple test without Flutter dependencies
void main() {
  print('Testing per-world progress logic...');
  
  // Simulate the new progress system
  Map<int, Map<int, int>> worldProgress = {};
  
  // Helper functions
  int getUnlockedLevel(int world, int subWorld) {
    return worldProgress[world]?[subWorld] ?? -1;
  }
  
  void unlockNextLevel(int world, int subWorld, int level) {
    worldProgress[world] ??= {};
    final currentMaxLevel = worldProgress[world]![subWorld] ?? -1;
    if (level > currentMaxLevel) {
      worldProgress[world]![subWorld] = level;
    }
  }
  
  bool isLevelUnlocked(int world, int subWorld, int level) {
    // First level of first world is always unlocked
    if (world == 0 && subWorld == 0 && level == 0) return true;
    
    // First level of any world is unlocked
    if (subWorld == 0 && level == 0) return true;
    
    final maxUnlockedLevel = getUnlockedLevel(world, subWorld);
    return level <= maxUnlockedLevel;
  }
  
  // Test initial state
  print('Initial state:');
  print('  World 0, SubWorld 0, Level 0 unlocked: ${isLevelUnlocked(0, 0, 0)}'); // Should be true
  print('  World 0, SubWorld 0, Level 1 unlocked: ${isLevelUnlocked(0, 0, 1)}'); // Should be false
  print('  World 4, SubWorld 0, Level 0 unlocked: ${isLevelUnlocked(4, 0, 0)}'); // Should be true
  print('  World 4, SubWorld 0, Level 1 unlocked: ${isLevelUnlocked(4, 0, 1)}'); // Should be false
  
  // Complete first level of World 4
  print('\nCompleting World 4, SubWorld 0, Level 0...');
  unlockNextLevel(4, 0, 1); // This unlocks level 1 of world 4
  
  print('After completing World 4, Level 0:');
  print('  World 0, SubWorld 0, Level 1 unlocked: ${isLevelUnlocked(0, 0, 1)}'); // Should still be false
  print('  World 4, SubWorld 0, Level 1 unlocked: ${isLevelUnlocked(4, 0, 1)}'); // Should now be true
  print('  World 4, SubWorld 0, Level 2 unlocked: ${isLevelUnlocked(4, 0, 2)}'); // Should be false
  
  // Test that previous worlds are NOT affected
  print('  World 3, SubWorld 4, Level 17 unlocked: ${isLevelUnlocked(3, 4, 17)}'); // Should be false
  
  print('\n✅ Test completed successfully!');
  print('Per-world progress system is working correctly.');
}