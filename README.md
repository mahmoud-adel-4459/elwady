# الوادي للذبائح — Al-Wady Butchery (تطبيق Flutter الأصلي)

تطبيق متجر إلكتروني متكامل للذبائح واللحوم الطازجة مبني بنظام **Flutter & Dart** بالكامل ومطابق بدقة فائقة لنظام التصميم الرسمي (Figma Design System).

---

## 🎨 مواصفات التصميم المعتمدة:
1. **الخطوط (Typography):**
   - خط **Cairo** المعتمد مع كامل مقاسات نظام التصميم (Display 32px, H1 28px, H2 24px, Section 18px, Body 14px, Price 22px).
2. **الألوان (Color Palette):**
   - درجات لون **دم الغزال الأساسي (Primary – Deer Blood Red #7B1118)** ودرجات الـ Light & Dark.
3. **التدفق ومنطق تسجيل الدخول (Authentication Flow):**
   - الدخول برقم الجوال فقط مع رمز التحقق السريع (OTP-first).
   - زر **"زائر"** في الأعلى ومحدد الدول العربية.
   - شاشة **"استكمال البيانات"** تظهر للعميل الجديد فقط.

---

## 🚀 كيفية بناء واستخراج ملف الـ APK:

### الطريقة الأولى: عبر GitHub Actions السحابي (⭐ الأسهل والأسرع دون تحميل برامج)
1. تم تجهيز ملف الأكشن في مسار:
   `.github/workflows/build_apk.yml`
2. ارفع مجلد المشروع على حسابك في GitHub.
3. توجه إلى تبويب **Actions** في مستودع GitHub واختر **Build Flutter APK**.
4. اضغط على **Run workflow**.
5. خلال 3 دقائق سينتهي البناء وستجد ملف **`app-release.apk`** جاهزاً للتنزيل والتثبيت مباشرة على أي هاتف أندرويد!

---

### الطريقة الثانية: بناء الـ APK محلياً على جهازك
إذا كان مثبت لديك **Flutter SDK** و **Android Studio / Java**:
```bash
cd alwady_flutter
flutter pub get
flutter build apk --release
```
ستجد الملف الناتج في المسار التالي:
`alwady_flutter/build/app/outputs/flutter-apk/app-release.apk`
