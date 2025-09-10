# 🛍️ Fake Store App - تطبيق المتجر الإلكتروني

[![Flutter](https://img.shields.io/badge/Flutter-3.8+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.8+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📱 نظرة عامة | Overview

تطبيق Flutter متكامل لمتجر إلكتروني مزيف يوفر تجربة تسوق واقعية مع ميزات متقدمة مثل المصادقة، إدارة المنتجات، السلة، المفضلة، والبحث.

A comprehensive Flutter fake store application that provides a realistic shopping experience with advanced features including authentication, product management, cart, favorites, and search functionality.

## ✨ الميزات الرئيسية | Key Features

### 🔐 نظام المصادقة | Authentication System
- تسجيل الدخول وإنشاء حساب جديد
- إدارة الجلسات والمستخدمين
- حماية البيانات الشخصية

### 🛒 إدارة المتجر | Store Management
- عرض المنتجات مع التصنيفات
- إضافة منتجات جديدة
- إدارة المخزون والمنتجات

### 🛍️ تجربة التسوق | Shopping Experience
- سلة التسوق التفاعلية
- قائمة المفضلة
- البحث المتقدم مع الفلاتر
- تفاصيل المنتجات

### 🎨 واجهة المستخدم | User Interface
- تصميم عصري وجذاب
- دعم الوضع المظلم والفاتح
- تجاوب كامل مع جميع الأجهزة
- رسوم متحركة سلسة

### 🔍 البحث والتصفية | Search & Filtering
- بحث ذكي في المنتجات
- فلترة متقدمة حسب الفئة والسعر
- اقتراحات البحث

## 🏗️ البنية التقنية | Technical Architecture

### 📁 هيكل المشروع | Project Structure
```
lib/
├── core/           # الملفات الأساسية
├── cubit/          # إدارة الحالة (BLoC Pattern)
├── data/           # نماذج البيانات والمستودعات
├── presentation/   # واجهات المستخدم
└── widgets/        # العناصر القابلة لإعادة الاستخدام
```

### 🛠️ التقنيات المستخدمة | Technologies Used
- **Flutter 3.8+** - إطار العمل الرئيسي
- **BLoC Pattern** - إدارة الحالة
- **HTTP & Dio** - طلبات الشبكة
- **Shared Preferences** - التخزين المحلي
- **Cached Network Image** - تخزين الصور مؤقتاً
- **Image Picker** - اختيار الصور
- **Shimmer** - تأثيرات التحميل

## 🚀 التثبيت والتشغيل | Installation & Setup

### المتطلبات الأساسية | Prerequisites
- Flutter SDK 3.8.0 أو أحدث
- Dart SDK 3.8.0 أو أحدث
- Android Studio / VS Code
- Git

### خطوات التثبيت | Installation Steps

1. **استنساخ المشروع | Clone the repository**
   ```bash
   git clone https://github.com/yourusername/fake_store_app.git
   cd fake_store_app
   ```

2. **تثبيت التبعيات | Install dependencies**
   ```bash
   flutter pub get
   ```

3. **تشغيل التطبيق | Run the app**
   ```bash
   flutter run
   ```

### إعدادات إضافية | Additional Setup

#### Android
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

## 📱 الميزات التفصيلية | Detailed Features

### 🏠 الشاشة الرئيسية | Home Screen
- عرض المنتجات المميزة
- التنقل بين التصنيفات
- البحث السريع
- إشعارات المستخدم

### 🔍 شاشة البحث | Search Screen
- شريط البحث الذكي
- فلترة متقدمة
- اقتراحات البحث
- عرض النتائج بتصميم شبكي

### 🛒 سلة التسوق | Shopping Cart
- إضافة/إزالة المنتجات
- تحديث الكميات
- حساب المجموع
- حفظ السلة محلياً

### ❤️ المفضلة | Favorites
- حفظ المنتجات المفضلة
- إدارة القائمة
- مزامنة مع الحساب

### ⚙️ الإعدادات | Settings
- تبديل المظهر (فاتح/مظلم)
- إدارة الحساب
- تفضيلات التطبيق
- تسجيل الخروج

## 🧪 الاختبار | Testing

### تشغيل الاختبارات | Run Tests
```bash
# اختبارات الوحدة
flutter test

# اختبارات التكامل
flutter test integration_test/
```

### تغطية الاختبارات | Test Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 📦 البناء والنشر | Build & Deploy

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 المساهمة | Contributing

نرحب بمساهماتكم! يرجى اتباع الخطوات التالية:

1. Fork المشروع
2. إنشاء فرع للميزة الجديدة (`git checkout -b feature/AmazingFeature`)
3. Commit التغييرات (`git commit -m 'Add some AmazingFeature'`)
4. Push إلى الفرع (`git push origin feature/AmazingFeature`)
5. فتح Pull Request

## 📄 الترخيص | License

هذا المشروع مرخص تحت رخصة MIT - راجع ملف [LICENSE](LICENSE) للتفاصيل.

## 📞 الدعم والاتصال | Support & Contact

- **المطور | Developer**: [اسمك]
- **البريد الإلكتروني | Email**: [your.email@example.com]
- **GitHub**: [https://github.com/yourusername](https://github.com/yourusername)

## 🙏 الشكر والتقدير | Acknowledgments

- فريق Flutter للعمل المذهل
- مجتمع Flutter العربي
- جميع المساهمين في المشروع

---

**Made with ❤️ using Flutter**

---

# 🛍️ Fake Store App - E-commerce Application

[![Flutter](https://img.shields.io/badge/Flutter-3.8+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.8+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📱 Overview

A comprehensive Flutter fake store application that provides a realistic shopping experience with advanced features including authentication, product management, cart, favorites, and search functionality.

## ✨ Key Features

### 🔐 Authentication System
- Login and registration
- Session management
- User data protection

### 🛒 Store Management
- Product display with categories
- Add new products
- Inventory management

### 🛍️ Shopping Experience
- Interactive shopping cart
- Favorites list
- Advanced search with filters
- Product details

### 🎨 User Interface
- Modern and attractive design
- Dark/Light theme support
- Full responsiveness
- Smooth animations

### 🔍 Search & Filtering
- Smart product search
- Advanced filtering by category and price
- Search suggestions

## 🏗️ Technical Architecture

### 📁 Project Structure
```
lib/
├── core/           # Core files
├── cubit/          # State management (BLoC Pattern)
├── data/           # Data models and repositories
├── presentation/   # User interfaces
└── widgets/        # Reusable components
```

### 🛠️ Technologies Used
- **Flutter 3.8+** - Main framework
- **BLoC Pattern** - State management
- **HTTP & Dio** - Network requests
- **Shared Preferences** - Local storage
- **Cached Network Image** - Image caching
- **Image Picker** - Image selection
- **Shimmer** - Loading effects

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK 3.8.0 or later
- Dart SDK 3.8.0 or later
- Android Studio / VS Code
- Git

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/fake_store_app.git
   cd fake_store_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Additional Setup

#### Android
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

## 📱 Detailed Features

### 🏠 Home Screen
- Featured products display
- Category navigation
- Quick search
- User notifications

### 🔍 Search Screen
- Smart search bar
- Advanced filtering
- Search suggestions
- Grid results display

### 🛒 Shopping Cart
- Add/remove products
- Update quantities
- Calculate totals
- Local cart persistence

### ❤️ Favorites
- Save favorite products
- List management
- Account synchronization

### ⚙️ Settings
- Theme switching (light/dark)
- Account management
- App preferences
- Logout

## 🧪 Testing

### Run Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/
```

### Test Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 📦 Build & Deploy

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the project
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support & Contact

- **Developer**: [Your Name]
- **Email**: [your.email@example.com]
- **GitHub**: [https://github.com/yourusername](https://github.com/yourusername)

## 🙏 Acknowledgments

- Flutter team for the amazing work
- Arabic Flutter community
- All project contributors

---

**Made with ❤️ using Flutter**
