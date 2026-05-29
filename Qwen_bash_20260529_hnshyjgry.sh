#!/bin/bash
mkdir -p AI-Flutter-Builder/.github/{workflows,scripts}
mkdir -p AI-Flutter-Builder/{lib,web,assets}

# 1️⃣ 01-ai-generate.yml
cat << 'YAML' > AI-Flutter-Builder/.github/workflows/01-ai-generate.yml
name: 🤖 AI Code Generator
on:
  issues:
    types: [opened, labeled]
env:
  GEMINI_API_KEY: ${{ secrets.GEMINI_API_KEY }}
  GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
jobs:
  generate:
    if: ${{ contains(github.event.issue.labels.*.name, 'generate') }}
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: python-version: '3.11'
      - name: Install jq
        run: sudo apt-get update && sudo apt-get install -y jq
      - name: Fetch Issue Body
        id: issue
        run: |
          BODY=$(gh issue view ${{ github.event.issue.number }} --json body -q .body)
          echo "body<<EOF" >> $GITHUB_OUTPUT
          echo "$BODY" >> $GITHUB_OUTPUT
          echo "EOF" >> $GITHUB_OUTPUT
      - name: Call Gemini AI
        id: ai
        run: |
          PROMPT=$(cat <<'PROMPT_END'
أنت مهندس Flutter خبير. بناءً على الوصف، أعد هيكل تطبيق كامل بصيغة JSON فقط.
المفاتيح المطلوبة: "files" (مسار الملف -> الكود)، "dependencies" (قائمة الحزم الإضافية إن وجدت).
اتبع: material3، دعم RTL، واجهة عربية، كود نظيف وجاهز للبناء.
الوصف:
${{ steps.issue.outputs.body }}
PROMPT_END
          )
          RESPONSE=$(curl -s -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$GEMINI_API_KEY" \
          -H "Content-Type: application/json" \
          -d "{\"contents\":[{\"parts\":[{\"text\":\"$PROMPT\"}]}]}")
          echo "$RESPONSE" | jq -r '.candidates[0].content.parts[0].text' | sed 's/```json//g;s/```//g' > ai_clean.json
      - name: Parse & Save Files
        run: python3 .github/scripts/parse_ai_output.py
      - name: Commit & Push
        run: |
          git config user.name "ai-builder"
          git config user.email "ai@github.com"
          git add -A
          git commit -m "🤖 AI generated from #${{ github.event.issue.number }}" || echo "No changes"
          git push
      - name: Comment on Issue
        run: gh issue comment ${{ github.event.issue.number }} --body "✅ تم توليد الكود. جاري تجهيز المعاينة الحية..."
YAML

# 2️⃣ 02-live-preview.yml
cat << 'YAML' > AI-Flutter-Builder/.github/workflows/02-live-preview.yml
name: 🌐 Live Preview (Web + QR)
on:
  push:
    branches: [main]
  workflow_run:
    workflows: ["🤖 AI Code Generator"]
    types: [completed]
permissions:
  pages: write
  id-token: write
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: flutter-version: '3.27.x'
      - run: flutter pub get
      - name: Build Web
        run: flutter build web --release --base-href="/${{ github.event.repository.name }}/"
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v4
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
          keep_files: true
      - name: QR Summary
        run: |
          URL="https://${{ github.repository_owner }}.github.io/${{ github.event.repository.name }}"
          echo "📱 رابط المعاينة: $URL" >> $GITHUB_STEP_SUMMARY
          echo "![QR](https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=$URL)" >> $GITHUB_STEP_SUMMARY
YAML

# 3️⃣ 03-build-android.yml
cat << 'YAML' > AI-Flutter-Builder/.github/workflows/03-build-android.yml
name: 📱 Build Android (APK + AAB)
on:
  workflow_dispatch:
  push:
    tags: ['v*']
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: flutter-version: '3.27.x'
      - run: flutter pub get
      - name: Build APK & AppBundle
        run: |
          flutter build apk --release
          flutter build appbundle --release
      - name: Release
        uses: softprops/action-gh-release@v2
        with:
          files: |
            build/app/outputs/flutter-apk/app-release.apk
            build/app/outputs/bundle/release/app-release.aab
          tag_name: android-${{ github.run_number }}
          name: "📦 Android Build #${{ github.run_number }}"
YAML

# 4️⃣ 04-build-ios.yml
cat << 'YAML' > AI-Flutter-Builder/.github/workflows/04-build-ios.yml
name: 🍎 Build iOS (IPA - No CodeSign)
on: workflow_dispatch
jobs:
  build:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: flutter-version: '3.27.x'
      - run: flutter pub get
      - name: Build IPA
        run: |
          flutter build ios --release --no-codesign
          cd build/ios/iphoneos
          mkdir -p Payload
          cp -r Runner.app Payload/
          zip -r ../Runner.ipa Payload
      - name: Release IPA
        uses: softprops/action-gh-release@v2
        with:
          files: build/ios/Runner.ipa
          tag_name: ios-${{ github.run_number }}
          name: "📦 iOS Build #${{ github.run_number }}"
YAML

# 5️⃣ parse_ai_output.py
cat << 'PY' > AI-Flutter-Builder/.github/scripts/parse_ai_output.py
import json, os
with open("ai_clean.json", "r", encoding="utf-8") as f:
    data = json.load(f)
files = data.get("files", {})
deps = data.get("dependencies", [])
with open("added_deps.txt", "w") as f:
    for dep in deps: f.write(f"{dep}\n")
for path, content in files.items():
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f: f.write(content)
    print(f"✅ {path}")
PY

# 6️⃣ lib/main.dart
cat << 'DART' > AI-Flutter-Builder/lib/main.dart
import 'package:flutter/material.dart';
void main() => runApp(const MyApp());
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const Scaffold(body: Center(child: Text('🤖 تم البناء بنجاح. أضف واجهاتك عبر Issue جديد.'))),
    );
  }
}
DART

# 7️⃣ pubspec.yaml
cat << 'YAML' > AI-Flutter-Builder/pubspec.yaml
name: ai_flutter_builder
description: منصة توليد تطبيقات Flutter بالذكاء الاصطناعي عبر GitHub
publish_to: 'none'
version: 1.0.0+1
environment:
  sdk: '>=3.0.0 <4.0.0'
dependencies:
  flutter:
    sdk: flutter
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
flutter:
  uses-material-design: true
YAML

# 8️⃣ .gitignore
cat << 'GITIGNORE' > AI-Flutter-Builder/.gitignore
# Flutter
build/
.dart_tool/
.packages
.pub-cache/
.pub/
# IDE
.vscode/
.idea/
*.swp
# OS
.DS_Store
Thumbs.db
GITIGNORE

# 9️⃣ README.md
cat << 'MD' > AI-Flutter-Builder/README.md
# 🤖 AI Flutter Builder
منصة توليد تطبيقات Android & iOS بالكامل داخل GitHub باستخدام ذكاء اصطناعي مجاني.

## 🚀 التفعيل السريع
1. ارفع المجلد كمستودع GitHub جديد.
2. فعّل GitHub Pages من الإعدادات.
3. أضف `GEMINI_API_KEY` في Secrets.
4. افتح Issue جديد → اكتب وصف التطبيق → أضف Label `generate`.
5. انتظر دقيقتين → ستجد رابط المعاينة + QR في Actions.

## 📦 البناء النهائي
- شغّل `workflow_dispatch` لـ `Build Android` أو `Build iOS` يدوياً.
- حمّل APK/AAB/IPA من Releases.

## ⚠️ ملاحظات
- iOS يُبنى بـ `--no-codesign`. استخدم `Sideloadly` أو `AltStore` للتثبيت المجاني.
- المعاينة تعمل عبر Web، للمعاينة Native أربط بـ Firebase App Distribution (مجاني).
MD

# 🔟 ضغط المجلد إلى ZIP
cd AI-Flutter-Builder
zip -r ../AI-Flutter-Builder.zip .
cd ..
echo "✅ تم إنشاء AI-Flutter-Builder.zip بنجاح. جاهز للرفع على GitHub."