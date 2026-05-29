# AI Flutter Builder

منصة متكاملة لبناء تطبيقات **Android** و **iOS** بالذكاء الاصطناعي عبر GitHub Actions — **مجاناً تماماً**.

## الميزات

- **AI مجاني**: يستخدم Gemini 2.0 Flash (مجاني، 60 طلب/دقيقة)
- **بناء تلقائي**: اكتب وصف التطبيق في Issue، AI يبني كل شيء
- **معاينة حية**: رابط مباشر + QR Code على GitHub Pages
- **Android APK/AAB**: بناء بنقرة واحدة
- **iOS IPA**: بناء بنقرة واحدة (تثبيت عبر Sideloadly/AltStore)
- **Material 3**: تصميم عصري مع دعم العربية و RTL

## طريقة الاستخدام

### 1. انسخ المستودع

- Fork أو استخدم هذا القالب
- اذهب إلى Settings → Pages → اختر `gh-pages` كالمصدر

### 2. أضف مفتاح AI

Settings → Secrets and variables → Actions → New secret:
- الاسم: `GEMINI_API_KEY`
- القيمة: مفتاح API من [Google AI Studio](https://aistudio.google.com/apikey)

### 3. أنشئ تطبيقك الأول

1. افتح **Issues** → **New Issue**
2. اكتب وصف التطبيق بالعربية أو الإنجليزية
   مثال: *"تطبيق تسوق عربي بحتوي على منتجات وفئات وسلة مشتريات"*
3. أضف Label: **`generate`**
4. انتظر 2-3 دقائق...

### 4. حمل التطبيق

- **Android**: اذهب إلى Actions → `Build Android` → Run workflow
- **iOS**: اذهب إلى Actions → `Build iOS` → Run workflow
- التحميل من Releases في الصفحة الرئيسية

## البنية

```
.github/
  workflows/
    01-ai-generate.yml    # توليد التطبيق من Issue
    02-live-preview.yml   # معاينة Web + QR
    03-build-android.yml   # بناء APK/AAB
    04-build-ios.yml       # بناء IPA
  scripts/
    ai_generator.py        # محرك AI الرئيسي
lib/
  main.dart                # نقطة البداية
web/
  index.html               # مدخل Flutter Web
```

## المتطلبات

- حساب GitHub (مجاني)
- مفتاح Gemini API (مجاني من Google AI Studio)
- للتثبيت الفعلي على جهاز: لا حاجة لمتجر (Sideloadly كافي)

## الترخيص

MIT - حرية كاملة في الاستخدام والتعديل والنشر.
