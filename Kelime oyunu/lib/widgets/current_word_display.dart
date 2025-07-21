import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';

class CurrentWordDisplay extends StatelessWidget {
  const CurrentWordDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameStateProvider>(
      builder: (context, gameState, child) {
        final currentWord = gameState.getCurrentWordString();

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.edit,
                color: Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  currentWord.isEmpty
                      ? 'Kelime oluşturmak için harfleri birleştirin'
                      : currentWord,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: currentWord.isEmpty
                        ? Colors.grey[600]
                        : const Color(0xFF4A90E2),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (currentWord.isNotEmpty) ...[
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    context.read<GameStateProvider>().clearCurrentWord();
                  },
                  child: Icon(
                    Icons.clear,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
