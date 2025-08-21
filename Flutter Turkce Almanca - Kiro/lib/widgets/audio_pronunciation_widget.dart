import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/feature_timer_provider.dart';
import '../providers/progress_provider.dart';

class AudioPronunciationWidget extends StatelessWidget {
  final String word;
  final VoidCallback? onPlay;

  const AudioPronunciationWidget({
    super.key,
    required this.word,
    this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<FeatureTimerProvider, ProgressProvider>(
      builder: (context, timerProvider, progressProvider, child) {
        final canPlay = timerProvider.canUseAudio();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: canPlay ? Colors.blue.shade50 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: canPlay ? Colors.blue.shade200 : Colors.grey.shade300,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed:
                    canPlay ? () => _playAudio(timerProvider, context) : null,
                icon: Icon(
                  Icons.volume_up,
                  color: canPlay ? Colors.blue : Colors.grey,
                  size: 20,
                ),
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(width: 4),
              Text(
                timerProvider.getAudioTimerDisplay(),
                style: TextStyle(
                  fontSize: 10,
                  color: canPlay ? Colors.blue.shade700 : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Show extension options if no audio available
              if (!canPlay) ...[
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: 16,
                    color: Colors.orange.shade600,
                  ),
                  onSelected: (value) {
                    if (value == 'ad') {
                      _watchAdForAudio(context, timerProvider);
                    } else if (value == 'ruby') {
                      _buyAudio(context, timerProvider, progressProvider);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'ad',
                      child: Row(
                        children: [
                          Icon(Icons.play_circle_outline, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Watch Ad (+3)'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'ruby',
                      enabled: progressProvider.rubies >= 3,
                      child: Row(
                        children: [
                          Icon(
                            Icons.diamond,
                            color: progressProvider.rubies >= 3
                                ? Colors.purple
                                : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '3 Rubies (+∞)',
                            style: TextStyle(
                              color: progressProvider.rubies >= 3
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _playAudio(FeatureTimerProvider timerProvider, BuildContext context) {
    if (timerProvider.canUseAudio()) {
      timerProvider.useAudio();
      onPlay?.call();

      // TODO: Implement actual audio playback
      // For now, just show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Playing pronunciation: $word'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _watchAdForAudio(
      BuildContext context, FeatureTimerProvider timerProvider) {
    // TODO: Integrate with actual ad system
    timerProvider.addAudioPlays(3);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ad watched! +3 audio plays'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _buyAudio(BuildContext context, FeatureTimerProvider timerProvider,
      ProgressProvider progressProvider) {
    if (progressProvider.rubies >= 3) {
      progressProvider.spendRubies(3);
      timerProvider.addAudioPlays(1000); // Simulate unlimited for current level

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unlimited audio for this level!'),
          backgroundColor: Colors.purple,
        ),
      );
    }
  }
}
