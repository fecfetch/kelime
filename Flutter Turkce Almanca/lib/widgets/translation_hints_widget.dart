import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/feature_timer_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/game_state_provider.dart';

class TranslationHintsWidget extends StatefulWidget {
  final dynamic hints; // Can be String (old format) or Map<String, String> (new format)
  final List<String> targetWords;
  final int world;
  final int subWorld;
  final int level;
  final String userLanguage; // User's preferred language for hints

  const TranslationHintsWidget({
    super.key,
    required this.hints,
    required this.targetWords,
    required this.world,
    required this.subWorld,
    required this.level,
    this.userLanguage = 'turkish', // Default to Turkish for backward compatibility
  });

  @override
  State<TranslationHintsWidget> createState() => _TranslationHintsWidgetState();
}

class _TranslationHintsWidgetState extends State<TranslationHintsWidget> {
  Set<int> _revealedHints = {};
  bool _showExtensionOptions = false;
  int? _lastRevealedHintIndex;

  @override
  void initState() {
    super.initState();
    // Load revealed hints for this level
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRevealedHints();
    });
  }

  // Get hints in user's preferred language
  String _getLocalizedHints() {
    if (widget.hints is String) {
      // Old format - return as is
      return widget.hints as String;
    } else if (widget.hints is Map<String, String>) {
      // New multilingual format
      final hintsMap = widget.hints as Map<String, String>;
      
      // Try to get hints in user's preferred language
      if (hintsMap.containsKey(widget.userLanguage)) {
        return hintsMap[widget.userLanguage]!;
      }
      
      // Fallback to first available language
      return hintsMap.values.first;
    }
    
    return ''; // Fallback for unexpected format
  }

  void _loadRevealedHints() {
    final timerProvider = context.read<FeatureTimerProvider>();
    _revealedHints = timerProvider.getRevealedHints(
        widget.world, widget.subWorld, widget.level);

    // Set the last revealed hint index to the highest index from saved hints
    // This is a reasonable approximation for existing saved data
    if (_revealedHints.isNotEmpty) {
      final sortedIndices = _revealedHints.toList()..sort();
      _lastRevealedHintIndex = sortedIndices.last;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<FeatureTimerProvider, ProgressProvider, GameStateProvider>(
      builder: (context, timerProvider, progressProvider, gameState, child) {
        final hintsList = _getLocalizedHints().split(' | ');

        // Update revealed hints from provider (in case they were auto-revealed)
        final currentRevealedHints = timerProvider.getRevealedHints(
            widget.world, widget.subWorld, widget.level);
        if (currentRevealedHints.length != _revealedHints.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadRevealedHints();
          });
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              // Compact hint display area
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    // All revealed hints display
                    if (_revealedHints.isNotEmpty) ...[
                      Container(
                        constraints: const BoxConstraints(maxHeight: 120),
                        child: SingleChildScrollView(
                          child: _buildRevealedHintsList(hintsList, gameState),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Show last revealed hint prominently if available
                    if (_revealedHints.isNotEmpty) ...[
                      _buildLastRevealedHint(hintsList, gameState),
                    ] else ...[
                      // Empty state message
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Revealed translations will appear here',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.6),
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Extension options when out of hints
              if (_showExtensionOptions)
                _buildExtensionOptions(
                    context, timerProvider, progressProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRevealedHintsList(
      List<String> hintsList, GameStateProvider gameState) {
    final sortedIndices = _revealedHints.toList()..sort();
    final hintWidgets = <Widget>[];

    for (int i = 0; i < sortedIndices.length; i++) {
      final index = sortedIndices[i];
      if (index < hintsList.length && index < widget.targetWords.length) {
        final hint = hintsList[index];
        final targetWord = widget.targetWords[index];
        final isWordFound = gameState.isWordFound(targetWord);

        hintWidgets.add(
          Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isWordFound
                  ? Colors.green.withOpacity(0.1)
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: isWordFound
                  ? Border.all(color: Colors.green.withOpacity(0.4))
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Translation text (crossed out if word found)
                Text(
                  hint,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isWordFound
                        ? Colors.white.withOpacity(0.6)
                        : Colors.white.withOpacity(0.9),
                    decoration: isWordFound ? TextDecoration.lineThrough : null,
                    decorationColor: Colors.white.withOpacity(0.8),
                    decorationThickness: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Show target word if found
                if (isWordFound) ...[
                  const SizedBox(height: 4),
                  Text(
                    targetWord.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        );
      }
    }

    return Wrap(
      alignment: WrapAlignment.center,
      children: hintWidgets,
    );
  }

  Widget _buildLastRevealedHint(
      List<String> hintsList, GameStateProvider gameState) {
    if (_revealedHints.isEmpty) {
      return const SizedBox.shrink();
    }

    // Find the most recently revealed hint that's still relevant
    // If we have a tracked last revealed hint, use it; otherwise find the best one
    int? bestIndex = _lastRevealedHintIndex;

    // If the tracked hint is for a found word, find a better one
    if (bestIndex != null && bestIndex < widget.targetWords.length) {
      final targetWord = widget.targetWords[bestIndex];
      if (gameState.isWordFound(targetWord)) {
        bestIndex = null; // Reset and find a better one
      }
    }

    // If we don't have a good tracked hint, find the best available one
    if (bestIndex == null) {
      final sortedIndices = _revealedHints.toList()
        ..sort(((a, b) => b.compareTo(a))); // Reverse sort to get highest first
      for (final index in sortedIndices) {
        if (index < widget.targetWords.length) {
          final targetWord = widget.targetWords[index];
          if (!gameState.isWordFound(targetWord)) {
            bestIndex = index;
            break;
          }
        }
      }

      // If no unfound word hints, just use the most recent one
      if (bestIndex == null && sortedIndices.isNotEmpty) {
        bestIndex = sortedIndices.first;
      }
    }

    if (bestIndex == null ||
        bestIndex >= hintsList.length ||
        bestIndex >= widget.targetWords.length) {
      return const SizedBox.shrink();
    }

    final hint = hintsList[bestIndex];
    final targetWord = widget.targetWords[bestIndex];
    final isWordFound = gameState.isWordFound(targetWord);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isWordFound
            ? Colors.green.withOpacity(0.15)
            : Colors.blue.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isWordFound
              ? Colors.green.withOpacity(0.5)
              : Colors.blue.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          // Translation text (crossed out if word found)
          Text(
            hint,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isWordFound ? Colors.white.withOpacity(0.7) : Colors.white,
              decoration: isWordFound ? TextDecoration.lineThrough : null,
              decorationColor: Colors.white.withOpacity(0.8),
              decorationThickness: 2,
            ),
            textAlign: TextAlign.center,
          ),
          // Show target word if found
          if (isWordFound) ...[
            const SizedBox(height: 8),
            Text(
              targetWord.toUpperCase(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }



  Widget _buildExtensionOptions(
    BuildContext context,
    FeatureTimerProvider timerProvider,
    ProgressProvider progressProvider,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            'Need more hints?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade200,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              // Watch ad option
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _watchAdForHints(timerProvider),
                  icon: const Icon(Icons.play_circle_outline, size: 16),
                  label: const Text('Ad (+2)', style: TextStyle(fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    minimumSize: const Size(0, 32),
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // Ruby option
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: progressProvider.rubies >= 5
                      ? () => _buyHints(timerProvider, progressProvider)
                      : null,
                  icon: const Icon(Icons.diamond, size: 16),
                  label: const Text('5💎 (+5)', style: TextStyle(fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: progressProvider.rubies >= 5
                        ? Colors.purple
                        : Colors.grey,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    minimumSize: const Size(0, 32),
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // Unlimited option
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: progressProvider.rubies >= 15
                      ? () =>
                          _buyUnlimitedHints(timerProvider, progressProvider)
                      : null,
                  icon: const Icon(Icons.all_inclusive, size: 16),
                  label: const Text('15💎 (∞)', style: TextStyle(fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: progressProvider.rubies >= 15
                        ? Colors.blue
                        : Colors.grey,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    minimumSize: const Size(0, 32),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _watchAdForHints(FeatureTimerProvider timerProvider) {
    // TODO: Integrate with actual ad system
    // For now, just give the hints
    timerProvider.addTranslationHints(2);

    setState(() {
      _showExtensionOptions = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ad watched! +2 translation hints'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _buyHints(
      FeatureTimerProvider timerProvider, ProgressProvider progressProvider) {
    if (progressProvider.rubies >= 5) {
      progressProvider.spendRubies(5);
      timerProvider.addTranslationHints(5);

      setState(() {
        _showExtensionOptions = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Purchased! +5 translation hints'),
          backgroundColor: Colors.purple,
        ),
      );
    }
  }

  void _buyUnlimitedHints(
      FeatureTimerProvider timerProvider, ProgressProvider progressProvider) {
    if (progressProvider.rubies >= 15) {
      progressProvider.spendRubies(15);
      timerProvider.setUnlimitedTranslation(const Duration(hours: 1));

      setState(() {
        _showExtensionOptions = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unlimited translation hints for 1 hour!'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }
}
