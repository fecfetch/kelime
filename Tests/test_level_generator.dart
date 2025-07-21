import 'lib/services/level_generator.dart';
import 'lib/services/word_validator.dart';

Future<void> main() async {
  print('Testing Level Generator...');
  
  // Test a few levels from different worlds
  final testCases = [
    [0, 0, 12], // Should use generator (A1 level)
    [0, 1, 5],  // Should use generator (A1 level)
    [2, 0, 0],  // Should use generator (B1 level)
    [4, 0, 0],  // Should use generator (C1 level)
  ];
  
  for (final testCase in testCases) {
    final world = testCase[0];
    final subWorld = testCase[1];
    final level = testCase[2];
    
    print('\n--- Testing World $world, SubWorld $subWorld, Level $level ---');
    
    final gameLevel = await LevelGenerator.generateLevel(world, subWorld, level);
    
    if (gameLevel == null) {
      print('❌ Failed to generate level!');
      continue;
    }
    
    print('Source Word: ${gameLevel.sourceWord}');
    print('Target Words: ${gameLevel.targetWords}');
    print('Hints: ${gameLevel.hints}');
    print('Valid Words: ${gameLevel.validWords}');
    
    // Validate the level
    final isValid = WordValidator.validateLevel(gameLevel.sourceWord, gameLevel.targetWords);
    print('Level Valid: $isValid');
    
    if (!isValid) {
      print('❌ INVALID LEVEL DETECTED!');
      for (final target in gameLevel.targetWords) {
        final canForm = WordValidator.canFormWord(gameLevel.sourceWord, target);
        print('  - $target from ${gameLevel.sourceWord}: $canForm');
      }
    } else {
      print('✅ Level is valid');
    }
  }
  
  print('\n--- Running Full Validation ---');
  final allValid = await LevelGenerator.validateAllLevels();
  print('All levels valid: $allValid');
}