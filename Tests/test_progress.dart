import 'lib/providers/progress_provider.dart';

void main() async {
  print('Testing new per-world progress system...');
  
  final progress = ProgressProvider();
  
  // Test initial state
  print('Initial state:');
  print('  World 0, SubWorld 0, Level 0 unlocked: ${progress.isLevelUnlocked(0, 0, 0)}'); // Should be true
  print('  World 0, SubWorld 0, Level 1 unlocked: ${progress.isLevelUnlocked(0, 0, 1)}'); // Should be false
  print('  World 4, SubWorld 0, Level 0 unlocked: ${progress.isLevelUnlocked(4, 0, 0)}'); // Should be true (first level of any world)
  print('  World 4, SubWorld 0, Level 1 unlocked: ${progress.isLevelUnlocked(4, 0, 1)}'); // Should be false
  
  // Complete first level of World 4
  print('\nCompleting World 4, SubWorld 0, Level 0...');
  await progress.unlockNextLevel(4, 0, 1); // This unlocks level 1 of world 4
  
  print('After completing World 4, Level 0:');
  print('  World 0, SubWorld 0, Level 1 unlocked: ${progress.isLevelUnlocked(0, 0, 1)}'); // Should still be false
  print('  World 4, SubWorld 0, Level 1 unlocked: ${progress.isLevelUnlocked(4, 0, 1)}'); // Should now be true
  print('  World 4, SubWorld 0, Level 2 unlocked: ${progress.isLevelUnlocked(4, 0, 2)}'); // Should be false
  
  // Test that previous worlds are NOT affected
  print('  World 3, SubWorld 4, Level 17 unlocked: ${progress.isLevelUnlocked(3, 4, 17)}'); // Should be false
  
  print('\nTest completed successfully! ✅');
}