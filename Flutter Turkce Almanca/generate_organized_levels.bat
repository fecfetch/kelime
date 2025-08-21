@echo off
echo Starting organized level generation...
dart run scripts/generate_levels_standalone.dart --languages tr:en,en:de,de:en
echo.
echo Generation completed! Check assets/levels/ directory for organized files.
pause