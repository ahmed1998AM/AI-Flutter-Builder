# AI Flutter Builder - Agent Guide

## Project Overview
AI-powered platform that generates Flutter Android/iOS apps via GitHub Issues + Gemini AI.

## Architecture
- `.github/workflows/01-ai-generate.yml` - Triggered by Issue with `generate` label
- `.github/workflows/02-live-preview.yml` - Builds web, deploys to GitHub Pages
- `.github/workflows/03-build-android.yml` - Manual workflow for APK/AAB
- `.github/workflows/04-build-ios.yml` - Manual workflow for IPA
- `.github/scripts/ai_generator.py` - Core AI engine (Gemini API + file generation)

## Key Patterns
- AI generates JSON with `files`, `dependencies`, `app_name`, `description`
- Python script writes files, updates pubspec.yaml, updates README
- All Flutter apps use Material 3, RTL, Arabic support
- Web preview at `https://{owner}.github.io/{repo}/`

## Commands
- `flutter pub get` - get dependencies
- `flutter analyze` - check code quality
- `flutter build web --release` - build web preview
- `flutter build apk --release` - build Android
- `flutter build ios --release --no-codesign` - build iOS

## Environment Variables
- `GEMINI_API_KEY` - Google Gemini API key
- `GH_TOKEN` - GitHub token (auto-provided in Actions)

## Development
- Template landing page: `lib/main.dart`
- Web entry: `web/index.html`
- AI script: `.github/scripts/ai_generator.py`
