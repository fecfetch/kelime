import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../providers/game_state_provider.dart';

class LetterCircle extends StatefulWidget {
  final List<String> letters;
  final Function(String) onWordFormed;

  const LetterCircle({
    super.key,
    required this.letters,
    required this.onWordFormed,
  });

  @override
  State<LetterCircle> createState() => _LetterCircleState();
}

class _LetterCircleState extends State<LetterCircle> {
  List<int> selectedIndices = [];
  List<Offset> letterPositions = [];
  List<String> shuffledLetters = [];
  final double radius = 120;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    _initializeLetters();
  }

  void _initializeLetters() {
    shuffledLetters = List.from(widget.letters);
    shuffledLetters.shuffle();
    _calculateLetterPositions();
  }

  void _calculateLetterPositions() {
    letterPositions.clear();
    final numLetters = shuffledLetters.length;
    final angleStep = 2 * math.pi / numLetters;
    
    for (int i = 0; i < numLetters; i++) {
      final angle = i * angleStep - math.pi / 2; // Start from top
      final x = radius * math.cos(angle);
      final y = radius * math.sin(angle);
      letterPositions.add(Offset(x, y));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: CustomPaint(
            size: Size(radius * 2.5, radius * 2.5),
            painter: LetterCirclePainter(
              letters: shuffledLetters,
              positions: letterPositions,
              selectedIndices: selectedIndices,
              radius: radius,
            ),
          ),
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      isDragging = true;
      selectedIndices.clear();
    });
    
    final localPosition = _getLocalPosition(details.localPosition);
    final nearestIndex = _getNearestLetterIndex(localPosition);
    
    if (nearestIndex != -1) {
      setState(() {
        selectedIndices.add(nearestIndex);
      });
      _updateCurrentWord();
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!isDragging) return;
    
    final localPosition = _getLocalPosition(details.localPosition);
    final nearestIndex = _getNearestLetterIndex(localPosition);
    
    if (nearestIndex != -1 && !selectedIndices.contains(nearestIndex)) {
      // Check if this creates a valid connection (adjacent or allows backtracking)
      if (selectedIndices.isEmpty || _isValidConnection(selectedIndices.last, nearestIndex)) {
        setState(() {
          selectedIndices.add(nearestIndex);
        });
        _updateCurrentWord();
      }
    } else if (nearestIndex != -1 && selectedIndices.length > 1 && 
               selectedIndices[selectedIndices.length - 2] == nearestIndex) {
      // Allow backtracking
      setState(() {
        selectedIndices.removeLast();
      });
      _updateCurrentWord();
    }
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      isDragging = false;
    });
    
    if (selectedIndices.length >= 2) {
      final word = selectedIndices.map((i) => shuffledLetters[i]).join('');
      widget.onWordFormed(word);
    }
    
    setState(() {
      selectedIndices.clear();
    });
    context.read<GameStateProvider>().clearCurrentWord();
  }

  Offset _getLocalPosition(Offset globalPosition) {
    // Convert to center-based coordinates
    final centerX = radius * 1.25;
    final centerY = radius * 1.25;
    return Offset(globalPosition.dx - centerX, globalPosition.dy - centerY);
  }

  int _getNearestLetterIndex(Offset position) {
    const threshold = 40.0;
    double minDistance = double.infinity;
    int nearestIndex = -1;
    
    for (int i = 0; i < letterPositions.length; i++) {
      final distance = (letterPositions[i] - position).distance;
      if (distance < threshold && distance < minDistance) {
        minDistance = distance;
        nearestIndex = i;
      }
    }
    
    return nearestIndex;
  }

  bool _isValidConnection(int from, int to) {
    // For now, allow any connection. In a more sophisticated version,
    // you might want to limit connections to adjacent letters only
    return true;
  }

  void _updateCurrentWord() {
    final currentWord = selectedIndices.map((i) => shuffledLetters[i]).toList();
    context.read<GameStateProvider>().setCurrentWord(currentWord);
  }

  void shuffle() {
    setState(() {
      shuffledLetters.shuffle();
      selectedIndices.clear();
    });
    context.read<GameStateProvider>().clearCurrentWord();
  }
}

class LetterCirclePainter extends CustomPainter {
  final List<String> letters;
  final List<Offset> positions;
  final List<int> selectedIndices;
  final double radius;

  LetterCirclePainter({
    required this.letters,
    required this.positions,
    required this.selectedIndices,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw connecting lines
    if (selectedIndices.length > 1) {
      final linePaint = Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round;
      
      for (int i = 0; i < selectedIndices.length - 1; i++) {
        final start = center + positions[selectedIndices[i]];
        final end = center + positions[selectedIndices[i + 1]];
        canvas.drawLine(start, end, linePaint);
      }
    }
    
    // Draw letters
    for (int i = 0; i < letters.length; i++) {
      final position = center + positions[i];
      final isSelected = selectedIndices.contains(i);
      
      // Draw letter background
      final backgroundPaint = Paint()
        ..color = isSelected ? Colors.orange : Colors.white
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(position, 25, backgroundPaint);
      
      // Draw letter border
      final borderPaint = Paint()
        ..color = isSelected ? Colors.deepOrange : const Color(0xFF4A90E2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      
      canvas.drawCircle(position, 25, borderPaint);
      
      // Draw letter text
      final textPainter = TextPainter(
        text: TextSpan(
          text: letters[i].toUpperCase(),
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF4A90E2),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      
      textPainter.layout();
      final textOffset = position - Offset(textPainter.width / 2, textPainter.height / 2);
      textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}