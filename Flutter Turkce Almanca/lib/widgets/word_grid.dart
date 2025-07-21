import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';

class WordGrid extends StatefulWidget {
  final List<String> targetWords;
  final List<String> hints;

  const WordGrid({super.key, required this.targetWords, required this.hints});

  @override
  State<WordGrid> createState() => _WordGridState();
}

class _WordGridState extends State<WordGrid> {
  Set<int> flippedCards = {};

  @override
  Widget build(BuildContext context) {
    return Consumer<GameStateProvider>(
      builder: (context, gameState, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Bu kelimeleri bulun:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              _buildWordsGrid(gameState),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWordsGrid(GameStateProvider gameState) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: widget.targetWords.asMap().entries.map((entry) {
        final index = entry.key;
        final word = entry.value;
        final hint = index < widget.hints.length ? widget.hints[index] : '';
        final isFound = gameState.isWordFound(word.toUpperCase());
        final isFlipped = flippedCards.contains(index);
        
        return _buildFlipCard(word, hint, isFound, isFlipped, index);
      }).toList(),
    );
  }

  Widget _buildFlipCard(String word, String hint, bool isFound, bool isFlipped, int index) {
    return GestureDetector(
      onTap: () {
        // Allow flipping for both found and unfound words
        setState(() {
          if (isFlipped) {
            flippedCards.remove(index);
          } else {
            flippedCards.add(index);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isFound 
              ? Colors.green.withOpacity(0.8) 
              : isFlipped 
                  ? Colors.orange.withOpacity(0.8)
                  : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isFound 
                ? Colors.green 
                : isFlipped 
                    ? Colors.orange
                    : Colors.white.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: isFlipped
              ? _buildHintSide(hint, word, isFound)
              : _buildWordSide(word, isFound),
        ),
      ),
    );
  }

  Widget _buildWordSide(String word, bool isFound) {
    return Consumer<GameStateProvider>(
      builder: (context, gameState, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: word.split('').asMap().entries.map((entry) {
                final index = entry.key;
                final letter = entry.value;
                final isLetterRevealed = gameState.isLetterRevealed(word, index);
                final shouldShowLetter = isFound || isLetterRevealed;
                
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: shouldShowLetter ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.7),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      shouldShowLetter ? letter : '',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: shouldShowLetter ? const Color(0xFF4A90E2) : Colors.white,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 4),
            Text(
              isFound ? 'Çeviri için dokun' : (gameState.isHardMode ? 'İlk harf için dokun' : 'İpucu için dokun'),
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHintSide(String hint, String word, bool isFound) {
    return Consumer<GameStateProvider>(
      builder: (context, gameState, child) {
        if (isFound) {
          // Show full Turkish translation for found words
          return Center(
            child: Text(
              hint,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          );
        } else {
          if (gameState.isHardMode) {
            // In hard mode, show only the first letter
            final firstLetter = word.isNotEmpty ? word[0].toUpperCase() : '?';
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'İlk harf:',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    firstLetter,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          } else {
            // In normal mode, show full Turkish translation
            return Center(
              child: Text(
                hint,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }
        }
      },
    );
  }
}