import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/feature_timer_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/game_state_provider.dart';

class CircularHintButton extends StatefulWidget {
  final String hints;
  final List<String> targetWords;
  final int world;
  final int subWorld;
  final int level;
  final VoidCallback? onHintRevealed;
  
  const CircularHintButton({
    super.key,
    required this.hints,
    required this.targetWords,
    required this.world,
    required this.subWorld,
    required this.level,
    this.onHintRevealed,
  });

  @override
  State<CircularHintButton> createState() => _CircularHintButtonState();
}

class _CircularHintButtonState extends State<CircularHintButton> {
  Set<int> _revealedHints = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRevealedHints();
    });
  }

  void _loadRevealedHints() {
    final timerProvider = context.read<FeatureTimerProvider>();
    _revealedHints = timerProvider.getRevealedHints(
        widget.world, widget.subWorld, widget.level);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<FeatureTimerProvider, ProgressProvider, GameStateProvider>(
      builder: (context, timerProvider, progressProvider, gameState, child) {
        final hintsList = widget.hints.split(' | ');
        final hasUnrevealedHints = _hasAvailableHints(hintsList, gameState);

        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            // Circular hint button
            GestureDetector(
              onTap: hasUnrevealedHints
                  ? () => _attemptRevealHint(timerProvider)
                  : null,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: timerProvider.canUseTranslation() && hasUnrevealedHints
                      ? Colors.blue
                      : Colors.grey,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.translate,
                  size: 36,
                  color: timerProvider.canUseTranslation() && hasUnrevealedHints
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Timer display under button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: timerProvider.canUseTranslation()
                    ? Colors.green.withOpacity(0.2)
                    : Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: timerProvider.canUseTranslation()
                      ? Colors.green.withOpacity(0.5)
                      : Colors.orange.withOpacity(0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: timerProvider.canUseTranslation()
                        ? Colors.green
                        : Colors.orange,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    timerProvider.getTranslationTimerDisplay(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: timerProvider.canUseTranslation()
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            

          ],
        ),
        );
      },
    );
  }

  bool _hasAvailableHints(List<String> hintsList, GameStateProvider gameState) {
    for (int i = 0; i < hintsList.length && i < widget.targetWords.length; i++) {
      final targetWord = widget.targetWords[i];
      final isWordFound = gameState.isWordFound(targetWord);
      
      if (!_revealedHints.contains(i) && !isWordFound) {
        return true;
      }
    }
    return false;
  }

  void _attemptRevealHint(FeatureTimerProvider timerProvider) {
    if (timerProvider.canUseTranslation()) {
      _revealRandomHint(timerProvider);
    } else {
      _showGetMoreHintsDialog(context);
    }
  }

  void _revealRandomHint(FeatureTimerProvider timerProvider) {
    final hintsList = widget.hints.split(' | ');
    final gameState = context.read<GameStateProvider>();
    final unrevealedIndices = <int>[];

    for (int i = 0; i < hintsList.length && i < widget.targetWords.length; i++) {
      final targetWord = widget.targetWords[i];
      final isWordFound = gameState.isWordFound(targetWord);
      
      if (!_revealedHints.contains(i) && !isWordFound) {
        unrevealedIndices.add(i);
      }
    }

    if (unrevealedIndices.isNotEmpty) {
      final randomIndex = unrevealedIndices[
          DateTime.now().millisecond % unrevealedIndices.length];

      setState(() {
        _revealedHints.add(randomIndex);
      });

      timerProvider.addRevealedHint(
          widget.world, widget.subWorld, widget.level, randomIndex);
      timerProvider.useTranslation();
      
      // Notify parent widget that a hint was revealed
      widget.onHintRevealed?.call();
    }
  }

  void _showGetMoreHintsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer2<FeatureTimerProvider, ProgressProvider>(
          builder: (context, timerProvider, progressProvider, child) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.translate, color: Colors.blue, size: 28),
                  const SizedBox(width: 8),
                  const Text('Need More Hints?'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'You\'re out of translation hints!',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Choose an option to get more hints:',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                // Watch ad option
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _watchAdForHints(timerProvider);
                    },
                    icon: const Icon(Icons.play_circle_outline),
                    label: const Text('Watch Ad (+2 hints)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Ruby options
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: progressProvider.rubies >= 5
                            ? () {
                                Navigator.of(context).pop();
                                _buyHints(timerProvider, progressProvider);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: progressProvider.rubies >= 5
                              ? Colors.purple
                              : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          minimumSize: const Size(0, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '5 translation hints',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.diamond, size: 16),
                                const SizedBox(width: 4),
                                const Text('5', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: progressProvider.rubies >= 15
                            ? () {
                                Navigator.of(context).pop();
                                _buyUnlimitedHints(timerProvider, progressProvider);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: progressProvider.rubies >= 15
                              ? Colors.blue
                              : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          minimumSize: const Size(0, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Unlimited hints for 1 hour',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.diamond, size: 16),
                                const SizedBox(width: 4),
                                const Text('15', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Cancel button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _watchAdForHints(FeatureTimerProvider timerProvider) {
    timerProvider.addTranslationHints(2);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ad watched! +2 translation hints'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _buyHints(FeatureTimerProvider timerProvider, ProgressProvider progressProvider) {
    if (progressProvider.rubies >= 5) {
      progressProvider.spendRubies(5);
      timerProvider.addTranslationHints(5);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Purchased! +5 translation hints'),
          backgroundColor: Colors.purple,
        ),
      );
    }
  }

  void _buyUnlimitedHints(FeatureTimerProvider timerProvider, ProgressProvider progressProvider) {
    if (progressProvider.rubies >= 15) {
      progressProvider.spendRubies(15);
      timerProvider.setUnlimitedTranslation(const Duration(hours: 1));
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unlimited translation hints for 1 hour!'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }
}