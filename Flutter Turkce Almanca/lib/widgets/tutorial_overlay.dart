import 'package:flutter/material.dart';

class TutorialOverlay extends StatefulWidget {
  final VoidCallback onComplete;
  final VoidCallback? onWordFormed;
  final VoidCallback? onCardTapped;

  const TutorialOverlay({
    super.key, 
    required this.onComplete,
    this.onWordFormed,
    this.onCardTapped,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with TickerProviderStateMixin {
  int currentStep = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<TutorialStep> tutorialSteps = [
    TutorialStep(
      title: "Word Chef'e Hoş Geldiniz!",
      description: "Bu kelime bulmaca oyununu nasıl oynayacağımızı öğrenelim.",
      position: TutorialPosition.center,
    ),
    TutorialStep(
      title: "Harf Çemberi",
      description: "Bu harfler bir çember şeklinde dizilmiştir. Bunları kullanarak kelimeler oluşturacaksınız.",
      position: TutorialPosition.bottom,
      highlightOffset: const Offset(0, -176),
      highlightSize: const Size(300, 300),
    ),
    TutorialStep(
      title: "Sürüklemeyi Deneyin!",
      description: "Şimdi harften harfe sürükleyerek kelime oluşturmayı deneyin. Hadi, deneyin!",
      position: TutorialPosition.bottom,
      highlightOffset: const Offset(0, -176),
      highlightSize: const Size(300, 300),
      isInteractive: true,
    ),
    TutorialStep(
      title: "Kelime Kartları",
      description: "Bu kartlar bulmanız gereken kelimeleri gösterir. İpucunu görmek için birine dokunun!",
      position: TutorialPosition.top,
      highlightOffset: const Offset(0, 55),
      highlightSize: const Size(600, 85),
      isInteractive: true,
    ),
    TutorialStep(
      title: "Mevcut Kelime Göstergesi",
      description: "Sürüklerken, mevcut kelimeniz burada görünür. Bu, ne oluşturduğunuzu görmenize yardımcı olur!",
      position: TutorialPosition.center,
      highlightOffset: const Offset(0, -365),
      highlightSize: const Size(600, 65),
    ),
    TutorialStep(
      title: "Oynamaya Hazır!",
      description: "Seviyeyi tamamlamak için tüm kelimeleri bulun. Takılırsanız ipucu butonunu (💡) kullanın. İyi şanslar!",
      position: TutorialPosition.center,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _pulseController.repeat(reverse: true);
    _animationController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step = tutorialSteps[currentStep];
    
    return Stack(
      children: [
        // Highlight border - only show if there's something to highlight
        if (step.highlightOffset != null && step.highlightSize != null)
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: HighlightPainter(
                    center: _getScreenCenter(context),
                    highlightOffset: step.highlightOffset!,
                    highlightSize: step.highlightSize!,
                    pulseScale: _pulseAnimation.value,
                  ),
                );
              },
            ),
          ),
        
        // Tutorial content bubble - positioned to not block interactions
        _buildTutorialContent(step),
        
        // Skip button
        Positioned(
          top: 50,
          right: 20,
          child: Material(
            color: Colors.transparent,
            child: TextButton(
              onPressed: _skipTutorial,
              style: TextButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Geç',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Offset _getScreenCenter(BuildContext context) {
    return Offset(
      MediaQuery.of(context).size.width / 2,
      MediaQuery.of(context).size.height / 2,
    );
  }

  Offset _getHighlightPosition(BuildContext context, int stepIndex) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    
    switch (stepIndex) {
      case 1: // Letter Circle
      case 2: // Try Dragging
        // Letter circle is in the middle area of the game
        return Offset(screenWidth / 2, appBarHeight + 200);
      case 3: // Word Cards
        // Word cards are at the bottom
        return Offset(screenWidth / 2, screenHeight - 150);
      case 4: // Current Word Display
        // Current word display is near the top
        return Offset(screenWidth / 2, appBarHeight + 80);
      default:
        return Offset(screenWidth / 2, screenHeight / 2);
    }
  }

  Widget _buildTutorialContent(TutorialStep step) {
    Widget content = Container(
      constraints: const BoxConstraints(maxWidth: 300),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            step.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A90E2),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            step.description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Progress indicator
              Row(
                children: List.generate(
                  tutorialSteps.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == currentStep
                          ? const Color(0xFF4A90E2)
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
              
              // Next/Done button
              ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  currentStep == tutorialSteps.length - 1 ? 'Başla!' : 'İleri',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    // Position the content based on the step to avoid blocking game elements
    switch (step.position) {
      case TutorialPosition.top:
        return Positioned(
          top: 100,
          left: 20,
          right: 20,
          child: content,
        );
      case TutorialPosition.bottom:
        return Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: content,
        );
      case TutorialPosition.center:
      default:
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.3,
          left: 20,
          right: 20,
          child: content,
        );
    }
  }

  void _nextStep() {
    if (currentStep < tutorialSteps.length - 1) {
      setState(() {
        currentStep++;
      });
      _animationController.reset();
      _animationController.forward();
    } else {
      _completeTutorial();
    }
  }

  void _skipTutorial() {
    _completeTutorial();
  }

  void _completeTutorial() {
    widget.onComplete();
  }
}

class TutorialStep {
  final String title;
  final String description;
  final TutorialPosition position;
  final Offset? highlightOffset;
  final Size? highlightSize;
  final bool isInteractive;

  TutorialStep({
    required this.title,
    required this.description,
    required this.position,
    this.highlightOffset,
    this.highlightSize,
    this.isInteractive = false,
  });
}

enum TutorialPosition { top, center, bottom }

class HighlightPainter extends CustomPainter {
  final Offset center;
  final Offset highlightOffset;
  final Size highlightSize;
  final double pulseScale;

  HighlightPainter({
    required this.center,
    required this.highlightOffset,
    required this.highlightSize,
    required this.pulseScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate the highlight rectangle
    final highlightCenter = center + highlightOffset;
    final rect = Rect.fromCenter(
      center: highlightCenter,
      width: highlightSize.width,
      height: highlightSize.height,
    );
    
    // Draw pulsing border
    final borderPaint = Paint()
      ..color = Colors.orange.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * pulseScale;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(15)),
      borderPaint,
    );

    // Draw subtle glow effect
    final glowPaint = Paint()
      ..color = Colors.orange.withOpacity(0.2 * pulseScale)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8 * pulseScale
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(15)),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}