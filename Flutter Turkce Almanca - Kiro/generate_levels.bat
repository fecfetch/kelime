@echo off
echo 🚀 Generating all game levels...
echo This may take a few minutes...
echo.

dart run scripts/generate_levels.dart

echo.
echo ✅ Level generation complete!
echo 💡 Run "flutter pub get" to refresh assets
pause