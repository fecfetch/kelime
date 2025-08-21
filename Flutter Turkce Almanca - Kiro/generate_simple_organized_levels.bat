@echo off
echo Starting simple organized level generation...
dart run scripts/generate_simple_organized_levels.dart
echo.
echo Generation completed! Check assets/levels/ directory for organized files.
echo.
echo Files created:
echo - en_a1_levels.json (90 A1 beginner levels)
echo - en_a2_levels.json (90 A2 elementary levels)  
echo - en_b1_levels.json (90 B1 intermediate levels)
echo - en_b2_levels.json (90 B2 upper-intermediate levels)
echo - en_c1_levels.json (90 C1 advanced levels)
echo - en_c2_levels.json (90 C2 proficient levels)
echo - index.json (master index file)
echo.
pause