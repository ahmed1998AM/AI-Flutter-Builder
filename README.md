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
