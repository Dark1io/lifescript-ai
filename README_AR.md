# LifeScript AI - مشروع Flutter جاهز

## ماذا يحتوي؟
- تسجيل دخول Firebase Google/Anonymous
- Chat AI
- حفظ المحادثات في Firestore
- Daily Chapters
- Profile
- UI داكن احترافي

## التشغيل على الجوال بدون لابتوب قوي
1. ارفع هذا المشروع إلى GitHub.
2. افتح codemagic.io.
3. اربط GitHub.
4. اختر Flutter Android build.
5. أضف ملف google-services.json داخل android/app.
6. Build APK.
7. حمّل APK وثبته على جوالك.

## مهم
- ضع OpenAI API Key داخل:
lib/services/ai_service.dart
مكان:
PUT_YOUR_OPENAI_API_KEY_HERE

للنشر الحقيقي لا تضع المفتاح داخل التطبيق؛ الأفضل استخدام Cloud Functions.
