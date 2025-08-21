import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../providers/game_state_provider.dart';
import '../providers/feature_timer_provider.dart';

class CircularLetterHintButton extends StatefulWidget {
  final VoidCallback? onLetterRevealed;

  const CircularLetterHintButton({
    super.key,
    this.onLetterRevealed,
  });

  @override
  State<CircularLetterHintButton> createState() =>
      _CircularLetterHintButtonState();
}

class _CircularLetterHintButtonState extends State<CircularLetterHintButton> {

  @override
  Widget build(BuildContext context) {
    return Consumer3<FeatureTimerProvider, ProgressProvider, GameStateProvider>(
      builder: (context, timerProvider, progressProvider, gameState, child) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circular letter hint button
              GestureDetector(
                onTap: () => _attemptRevealLetter(timerProvider, gameState),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: timerProvider.canUseLetter() 
                        ? Colors.orange 
                        : Colors.grey,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.lightbulb_outline,
                    size: 36,
                    color: timerProvider.canUseLetter()
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Timer display under button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: timerProvider.canUseLetter()
                      ? Colors.orange.withValues(alpha: 0.2)
                      : Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: timerProvider.canUseLetter()
                        ? Colors.orange.withValues(alpha: 0.5)
                        : Colors.grey.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: timerProvider.canUseLetter() 
                          ? Colors.orange 
                          : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      timerProvider.getLetterTimerDisplay(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: timerProvider.canUseLetter() 
                            ? Colors.orange 
                            : Colors.grey,
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

  void _attemptRevealLetter(FeatureTimerProvider timerProvider, GameStateProvider gameState) {
    if (timerProvider.canUseLetter()) {
      _useLetter(timerProvider, gameState);
    } else {
      _showGetMoreLetterHintsDialog(context);
    }
  }

  void _useLetter(FeatureTimerProvider timerProvider, GameStateProvider gameState) {
    timerProvider.useLetter();
    gameState.useHint();
    
    widget.onLetterRevealed?.call();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bir harf açıldı!'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _showGetMoreLetterHintsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer2<FeatureTimerProvider, ProgressProvider>(
          builder: (context, timerProvider, progressProvider, child) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.orange, size: 28),
                  const SizedBox(width: 8),
                  const Text('Need More Letter Hints?'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'You\'re out of letter hints!',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Choose an option to get more letter hints:',
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
                      _watchAdForLetters(timerProvider);
                    },
                    icon: const Icon(Icons.play_circle_outline),
                    label: const Text('Watch Ad (+4 letter hints)'),
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
                                _buyLetters(timerProvider, progressProvider);
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
                              '6 letter hints',
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
                        onPressed: progressProvider.rubies >= 100
                            ? () {
                                Navigator.of(context).pop();
                                _buyUnlimitedLetters(timerProvider, progressProvider);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: progressProvider.rubies >= 100
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
                              'Unlimited letter hints for 1 hour',
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
                                const Text('100', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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

  void _watchAdForLetters(FeatureTimerProvider timerProvider) {
    // TODO: Integrate with actual ad system
    timerProvider.addLetterHints(4);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ad watched! +4 letter hints'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _buyLetters(FeatureTimerProvider timerProvider, ProgressProvider progressProvider) {
    if (progressProvider.rubies >= 5) {
      progressProvider.spendRubies(5);
      timerProvider.addLetterHints(6);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Purchased! +6 letter hints'),
          backgroundColor: Colors.purple,
        ),
      );
    }
  }

  void _buyUnlimitedLetters(FeatureTimerProvider timerProvider, ProgressProvider progressProvider) {
    if (progressProvider.rubies >= 100) {
      progressProvider.spendRubies(100);
      timerProvider.setUnlimitedLetter(const Duration(hours: 1));
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unlimited letter hints for 1 hour!'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }
}