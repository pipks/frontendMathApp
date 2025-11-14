# Math Master App - Eksiksiz Geliştirme Yol Haritası

## Proje Özeti

**Proje Adı:** Math Master (Matematik Ustası)
**Hedef Kitle:** 7-10 yaş arası çocuklar
**Platform:** Flutter (iOS, Android, Web)
**Dil:** Türkçe (Ana dil), İngilizce (İkincil dil)

**Ana Özellikler:**
- 4 Matematik Modülü (Toplama, Çıkarma, Çarpma, Bölme)
- Offline-First Veritabanı (Drift + Supabase)
- 3 Ana Motor Sistemi (Soru, Analiz, Adaptif)
- Çok Dilli Destek (i18n)
- Çocuklara Özel UI/UX Tasarımı

---

## Gerekli Araçlar ve API Anahtarları

### 1. Geliştirme Ortamı
- **Flutter SDK**: 3.16.0 veya üzeri
- **Dart SDK**: 3.2.0 veya üzeri
- **IDE**: VS Code veya Android Studio
- **Git**: Versiyon kontrolü için

### 2. Supabase Hesabı ve Anahtarlar
- **Supabase URL**: `https://[project-id].supabase.co`
- **Supabase Anon Key**: Dashboard'dan alınacak
- **Kayıt**: https://supabase.com (Ücretsiz plan yeterli)

**Supabase Kurulum Adımları:**
1. Supabase.com'da hesap oluştur
2. Yeni proje oluştur (Proje adı: math-master-app)
3. Project Settings > API > URL ve anon key'i kaydet
4. `.env` dosyasına ekle

### 3. Font Dosyası
- **Poppins Font**: Google Fonts'tan indirilecek
- **İndirme Linki**: https://fonts.google.com/specimen/Poppins
- **Gerekli Ağırlıklar**: Regular (400), Medium (500), SemiBold (600), Bold (700)

### 4. Opsiyonel (Gelişmiş Özellikler için)
- **Firebase** (Analytics ve Crashlytics için)
- **Sentry** (Hata takibi için)

### 5. Gerekli Dosya Yapısı
```
.env                    # Ortam değişkenleri (GIT'e EKLENMEYECEK!)
assets/
  fonts/
    Poppins-Regular.ttf
    Poppins-Medium.ttf
    Poppins-SemiBold.ttf
    Poppins-Bold.ttf
  images/               # İkonlar ve görseller
    logo.png
    modules/            # Modül ikonları
```

---

## BÖLÜM 1: Proje Kurulumu ve Temel Yapı

**Tahmini Süre:** 2-3 saat
**Test Noktası:** Uygulama açılıyor ve boş ekran görünüyor

### 1.1 Flutter Projesi Oluşturma
```bash
flutter create math_master_app
cd math_master_app
```

### 1.2 Bağımlılıklar (pubspec.yaml)

**Ana Paketler:**
```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3

  # Routing
  go_router: ^13.0.0

  # Database
  drift: ^2.14.0
  sqlite3_flutter_libs: ^0.5.18
  path_provider: ^2.1.1
  path: ^1.8.3

  # Supabase
  supabase_flutter: ^2.0.0

  # Localization
  flutter_localizations:
    sdk: flutter
  intl: any

  # UI Utilities
  google_fonts: ^6.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1

  # Code Generation
  build_runner: ^2.4.7
  riverpod_generator: ^2.3.9
  drift_dev: ^2.14.0
  custom_lint: ^0.5.7
  riverpod_lint: ^2.3.7

flutter:
  generate: true
  uses-material-design: true

  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Medium.ttf
          weight: 500
        - asset: assets/fonts/Poppins-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
```

### 1.3 l10n.yaml Oluşturma

```yaml
arb-dir: lib/core/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### 1.4 .env Dosyası Oluşturma

```env
SUPABASE_URL=your_supabase_url_here
SUPABASE_ANON_KEY=your_supabase_anon_key_here
```

### 1.5 .gitignore Güncelleme

```gitignore
# Env dosyaları
.env
.env.*

# Build dosyaları
*.g.dart
*.freezed.dart
build/

# IDE
.idea/
.vscode/
*.iml
*.code-workspace
```

### 1.6 Klasör Yapısı Oluşturma

```
lib/
├── core/
│   ├── theme/
│   ├── widgets/
│   │   ├── buttons/
│   │   ├── cards/
│   │   ├── feedback/
│   │   └── layouts/
│   ├── routing/
│   ├── database/
│   │   ├── tables/
│   │   ├── daos/
│   │   └── seed/
│   ├── services/
│   ├── l10n/
│   ├── engines/
│   │   ├── question_engine/
│   │   ├── analysis_engine/
│   │   └── adaptive_engine/
│   └── providers/
│
├── features/
│   ├── auth/
│   ├── onboarding/
│   ├── home/
│   ├── profile/
│   ├── addition/
│   ├── subtraction/
│   ├── multiplication/
│   └── division/
│
└── main.dart
```

### Test Adımları (Bölüm 1)
1. `flutter pub get` çalıştır
2. `flutter run` ile uygulamayı başlat
3. Hata olmadan derleniyor mu kontrol et
4. Beyaz/boş ekran görünmeli

---

## BÖLÜM 2: Core - Theme ve Stil Sistemi

**Tahmini Süre:** 2 saat
**Test Noktası:** Renklerin ve yazı tiplerinin doğru göründüğünü test et

### 2.1 Dosyalar

#### `lib/core/theme/app_colors.dart`
```dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const primary = Color(0xFF2196F3);
  static const primaryLight = Color(0xFF64B5F6);
  static const primaryDark = Color(0xFF1976D2);

  // Secondary Colors
  static const secondary = Color(0xFFFF9800);
  static const secondaryLight = Color(0xFFFFB74D);
  static const secondaryDark = Color(0xFFF57C00);

  // Feedback Colors
  static const success = Color(0xFF4CAF50);
  static const successLight = Color(0xFF81C784);
  static const error = Color(0xFFF44336);
  static const errorLight = Color(0xFFE57373);
  static const warning = Color(0xFFFFC107);

  // Module Colors
  static const additionColor = Color(0xFF2196F3);
  static const subtractionColor = Color(0xFFE91E63);
  static const multiplicationColor = Color(0xFF9C27B0);
  static const divisionColor = Color(0xFF4CAF50);

  // Neutral Colors
  static const background = Color(0xFFF5F5F5);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
  static const divider = Color(0xFFBDBDBD);
}
```

#### `lib/core/theme/app_text_styles.dart`
```dart
import 'package:flutter/material.dart';

class AppTextStyles {
  static const h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static const bodyLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const bodyMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const question = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const button = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const caption = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );
}
```

#### `lib/core/theme/app_spacing.dart`
```dart
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

class AppSizes {
  static const buttonHeight = 60.0;
  static const buttonMinWidth = 120.0;

  static const cardMinHeight = 100.0;
  static const cardBorderRadius = 16.0;

  static const iconSmall = 24.0;
  static const iconMedium = 32.0;
  static const iconLarge = 48.0;

  static const moduleCardHeight = 140.0;
  static const moduleCardWidth = 160.0;
}
```

#### `lib/core/theme/app_theme.dart`
```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Poppins',

      textTheme: const TextTheme(
        displayLarge: AppTextStyles.h1,
        displayMedium: AppTextStyles.h2,
        displaySmall: AppTextStyles.h3,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        labelLarge: AppTextStyles.button,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
      ),

      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
```

### Test Adımları (Bölüm 2)
1. Tema dosyalarını oluştur
2. `main.dart`'ta temayı uygula
3. Test ekranı oluştur ve renkleri/yazı tiplerini göster
4. Hot reload ile değişiklikleri test et

---

## BÖLÜM 3: Localization (i18n) Sistemi

**Tahmini Süre:** 1.5 saat
**Test Noktası:** Dil değiştirme çalışıyor

### 3.1 ARB Dosyaları

#### `lib/core/l10n/app_en.arb`
```json
{
  "@@locale": "en",

  "appTitle": "Math Master",
  "@appTitle": {
    "description": "Application title"
  },

  "welcome": "Welcome!",
  "getStarted": "Get Started",

  "moduleAddition": "Addition",
  "moduleSubtraction": "Subtraction",
  "moduleMultiplication": "Multiplication",
  "moduleDivision": "Division",

  "practiceMode": "Practice Mode",
  "timedChallenge": "Timed Challenge",

  "correctAnswer": "Correct! 🎉",
  "wrongAnswer": "Oops! Try again",
  "correctAnswerWas": "The correct answer was: {answer}",
  "@correctAnswerWas": {
    "placeholders": {
      "answer": {
        "type": "int"
      }
    }
  },

  "score": "Score: {score}",
  "@score": {
    "placeholders": {
      "score": {
        "type": "int"
      }
    }
  },

  "commonOk": "OK",
  "commonCancel": "Cancel",
  "commonSave": "Save",
  "commonContinue": "Continue"
}
```

#### `lib/core/l10n/app_tr.arb`
```json
{
  "@@locale": "tr",

  "appTitle": "Matematik Ustası",
  "welcome": "Hoş Geldin!",
  "getStarted": "Başla",

  "moduleAddition": "Toplama",
  "moduleSubtraction": "Çıkarma",
  "moduleMultiplication": "Çarpma",
  "moduleDivision": "Bölme",

  "practiceMode": "Pratik Modu",
  "timedChallenge": "Süre ile Yarışma",

  "correctAnswer": "Doğru! 🎉",
  "wrongAnswer": "Hata! Tekrar dene",
  "correctAnswerWas": "Doğru cevap: {answer}",

  "score": "Puan: {score}",

  "commonOk": "Tamam",
  "commonCancel": "İptal",
  "commonSave": "Kaydet",
  "commonContinue": "Devam Et"
}
```

### 3.2 Localization Provider

#### `lib/core/providers/locale_provider.dart`
```dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    return const Locale('tr');
  }

  void setLocale(Locale locale) {
    state = locale;
  }

  void toggleLanguage() {
    state = state.languageCode == 'tr'
        ? const Locale('en')
        : const Locale('tr');
  }
}
```

### 3.3 Code Generation Komutu
```bash
flutter gen-l10n
flutter pub run build_runner build --delete-conflicting-outputs
```

### Test Adımları (Bölüm 3)
1. ARB dosyalarını oluştur
2. `flutter gen-l10n` komutunu çalıştır
3. Test ekranında metinleri göster
4. Dil değiştir butonuyla test et

---

## BÖLÜM 4: Database - Drift Setup ve Tablolar

**Tahmini Süre:** 3-4 saat
**Test Noktası:** Veritabanı oluşuyor ve veri kaydediliyor

### 4.1 Tablo Tanımlamaları

#### `lib/core/database/tables/students.dart`
```dart
import 'package:drift/drift.dart';

class Students extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().withLength(min: 3, max: 50)();
  TextColumn get passwordHash => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  TextColumn get supabaseId => text().nullable()();
}
```

#### `lib/core/database/tables/patterns.dart`
```dart
import 'package:drift/drift.dart';

class Patterns extends Table {
  TextColumn get id => text()();
  IntColumn get version => integer()();
  TextColumn get moduleType => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  IntColumn get difficulty => integer()();
  IntColumn get minValue => integer()();
  IntColumn get maxValue => integer()();
  BoolColumn get hasCarryOver => boolean()();
  IntColumn get digitCount => integer()();
  TextColumn get metadata => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
```

#### `lib/core/database/tables/error_types.dart`
```dart
import 'package:drift/drift.dart';

class ErrorTypes extends Table {
  TextColumn get code => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get moduleType => text()();
  TextColumn get severity => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {code};
}
```

#### `lib/core/database/tables/test_sessions.dart`
```dart
import 'package:drift/drift.dart';

class TestSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get studentId => integer().references(Students, #id)();
  TextColumn get moduleType => text()();
  TextColumn get sessionType => text()(); // 'practice' or 'timed'
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get totalQuestions => integer().withDefault(const Constant(0))();
  IntColumn get correctAnswers => integer().withDefault(const Constant(0))();
  IntColumn get score => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  TextColumn get supabaseId => text().nullable()();
}
```

#### `lib/core/database/tables/test_results.dart`
```dart
import 'package:drift/drift.dart';

class TestResults extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(TestSessions, #id)();
  TextColumn get patternId => text().references(Patterns, #id)();
  IntColumn get operand1 => integer()();
  IntColumn get operand2 => integer()();
  IntColumn get correctAnswer => integer()();
  IntColumn get userAnswer => integer()();
  BoolColumn get isCorrect => boolean()();
  IntColumn get responseTime => integer()(); // milliseconds
  TextColumn get detectedErrorType => text().nullable()();
  DateTimeColumn get answeredAt => dateTime()();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
}
```

#### `lib/core/database/tables/student_analytics.dart`
```dart
import 'package:drift/drift.dart';

class StudentAnalytics extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get studentId => integer().references(Students, #id)();
  TextColumn get moduleType => text()();
  TextColumn get analysisData => text()(); // JSON
  DateTimeColumn get analyzedAt => dateTime()();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
}
```

### 4.2 Ana Database Dosyası

#### `lib/core/database/app_database.dart`
```dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/students.dart';
import 'tables/patterns.dart';
import 'tables/error_types.dart';
import 'tables/test_sessions.dart';
import 'tables/test_results.dart';
import 'tables/student_analytics.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Students,
  Patterns,
  ErrorTypes,
  TestSessions,
  TestResults,
  StudentAnalytics,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'math_app.sqlite'));
      return NativeDatabase(file);
    });
  }
}
```

### 4.3 Code Generation
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4.4 Database Provider

#### `lib/core/providers/database_provider.dart`
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/app_database.dart';

part 'database_provider.g.dart';

@riverpod
AppDatabase database(DatabaseRef ref) {
  return AppDatabase();
}
```

### Test Adımları (Bölüm 4)
1. Tüm tablo dosyalarını oluştur
2. `app_database.dart` dosyasını oluştur
3. `flutter pub run build_runner build` komutunu çalıştır
4. Hataları gider
5. Test ekranında veritabanına veri yaz ve oku

---

## BÖLÜM 5: Core Widgets - Butonlar ve Kartlar

**Tahmini Süre:** 2 saat
**Test Noktası:** Özel widget'lar doğru görünüyor

### 5.1 Primary Button

#### `lib/core/widgets/buttons/primary_button.dart`
```dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;

  const PrimaryButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          disabledBackgroundColor: AppColors.divider,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(text, style: AppTextStyles.button),
      ),
    );
  }
}
```

### 5.2 Module Card

#### `lib/core/widgets/cards/module_card.dart`
```dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class ModuleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ModuleCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
        child: Container(
          height: AppSizes.moduleCardHeight,
          width: AppSizes.moduleCardWidth,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: AppSizes.iconLarge, color: Colors.white),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: AppTextStyles.h3.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 5.3 Feedback Widgets

#### `lib/core/widgets/feedback/success_feedback.dart`
```dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class SuccessFeedback extends StatelessWidget {
  final String message;
  final VoidCallback? onComplete;

  const SuccessFeedback({
    required this.message,
    this.onComplete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.success.withOpacity(0.95),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              size: 120,
              color: Colors.white,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: AppTextStyles.h1.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
```

#### `lib/core/widgets/feedback/error_feedback.dart`
```dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class ErrorFeedback extends StatelessWidget {
  final String message;
  final String? correctAnswer;
  final VoidCallback? onTryAgain;

  const ErrorFeedback({
    required this.message,
    this.correctAnswer,
    this.onTryAgain,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.error.withOpacity(0.95),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.close_rounded,
              size: 120,
              color: Colors.white,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: AppTextStyles.h1.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            if (correctAnswer != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                correctAnswer!,
                style: AppTextStyles.h2.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

### Test Adımları (Bölüm 5)
1. Widget dosyalarını oluştur
2. Test sayfası oluştur
3. Her widget'ı farklı durumlarla test et
4. Animasyonları kontrol et

---

## BÖLÜM 6: Routing - GoRouter Kurulumu

**Tahmini Süre:** 1.5 saat
**Test Noktası:** Sayfalar arası geçiş çalışıyor

### 6.1 Route Paths

#### `lib/core/routing/route_paths.dart`
```dart
class RoutePaths {
  static const onboarding = '/';
  static const home = '/home';

  // Auth
  static const login = '/login';

  // Modules
  static const additionMenu = '/addition';
  static const additionPractice = '/addition/practice';
  static const additionTimed = '/addition/timed';

  static const subtractionMenu = '/subtraction';
  static const subtractionPractice = '/subtraction/practice';
  static const subtractionTimed = '/subtraction/timed';

  static const multiplicationMenu = '/multiplication';
  static const multiplicationPractice = '/multiplication/practice';
  static const multiplicationTimed = '/multiplication/timed';

  static const divisionMenu = '/division';
  static const divisionPractice = '/division/practice';
  static const divisionTimed = '/division/timed';

  // Profile
  static const profile = '/profile';
}
```

### 6.2 App Router

#### `lib/core/routing/app_router.dart`
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/home/screens/home_screen.dart';
import 'route_paths.dart';

final appRouter = GoRouter(
  initialLocation: RoutePaths.onboarding,
  routes: [
    GoRoute(
      path: RoutePaths.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RoutePaths.home,
      builder: (context, state) => const HomeScreen(),
    ),
    // Diğer route'lar sonraki bölümlerde eklenecek
  ],
);
```

### Test Adımları (Bölüm 6)
1. Router dosyalarını oluştur
2. `main.dart`'ta router'ı yapılandır
3. `context.go()` ile navigasyon test et
4. Geri butonu çalışıyor mu kontrol et

---

## BÖLÜM 7: Features - Onboarding Ekranı

**Tahmini Süre:** 1 saat
**Test Noktası:** Onboarding ekranı görünüyor ve home'a yönlendiriyor

### 7.1 Onboarding Screen

#### `lib/features/onboarding/screens/onboarding_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/l10n/app_localizations.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  l10n.appTitle,
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 48,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.welcome,
                  style: AppTextStyles.h2.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                PrimaryButton(
                  text: l10n.getStarted,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    context.go(RoutePaths.home);
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### Test Adımları (Bölüm 7)
1. Onboarding ekranını oluştur
2. Uygulamayı başlat
3. Ekranın doğru görüntülendiğini kontrol et
4. "Başla" butonuna bas, home'a gitmeli

---

## BÖLÜM 8: Features - Home Ekranı

**Tahmini Süre:** 2 saat
**Test Noktası:** 4 modül kartı görünüyor ve tıklanabiliyor

### 8.1 Home Screen

#### `lib/features/home/screens/home_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/cards/module_card.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/routing/route_paths.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.welcome,
              style: AppTextStyles.h1,
            ),
            const SizedBox(height: AppSpacing.xl),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                children: [
                  ModuleCard(
                    title: l10n.moduleAddition,
                    icon: Icons.add,
                    color: AppColors.additionColor,
                    onTap: () {
                      context.push(RoutePaths.additionMenu);
                    },
                  ),
                  ModuleCard(
                    title: l10n.moduleSubtraction,
                    icon: Icons.remove,
                    color: AppColors.subtractionColor,
                    onTap: () {
                      context.push(RoutePaths.subtractionMenu);
                    },
                  ),
                  ModuleCard(
                    title: l10n.moduleMultiplication,
                    icon: Icons.close,
                    color: AppColors.multiplicationColor,
                    onTap: () {
                      context.push(RoutePaths.multiplicationMenu);
                    },
                  ),
                  ModuleCard(
                    title: l10n.moduleDivision,
                    icon: Icons.percent,
                    color: AppColors.divisionColor,
                    onTap: () {
                      context.push(RoutePaths.divisionMenu);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Test Adımları (Bölüm 8)
1. Home ekranını oluştur
2. Onboarding'den home'a git
3. 4 modül kartının doğru görünmesini kontrol et
4. Kartlara tıkla (şimdilik hata verecek, normal)

---

## BÖLÜM 9: Engine System - Question Engine

**Tahmini Süre:** 3 saat
**Test Noktası:** Soru üretimi çalışıyor

### 9.1 Models

#### `lib/core/engines/question_engine/models/module_type.dart`
```dart
enum ModuleType {
  addition,
  subtraction,
  multiplication,
  division;

  String get displayName {
    switch (this) {
      case ModuleType.addition:
        return 'Addition';
      case ModuleType.subtraction:
        return 'Subtraction';
      case ModuleType.multiplication:
        return 'Multiplication';
      case ModuleType.division:
        return 'Division';
    }
  }

  String get operator {
    switch (this) {
      case ModuleType.addition:
        return '+';
      case ModuleType.subtraction:
        return '-';
      case ModuleType.multiplication:
        return '×';
      case ModuleType.division:
        return '÷';
    }
  }
}
```

#### `lib/core/engines/question_engine/models/question.dart`
```dart
class Question {
  final String id;
  final ModuleType moduleType;
  final String patternId;
  final int operand1;
  final int operand2;
  final int correctAnswer;
  final int difficulty;
  final DateTime createdAt;

  Question({
    required this.id,
    required this.moduleType,
    required this.patternId,
    required this.operand1,
    required this.operand2,
    required this.correctAnswer,
    required this.difficulty,
    required this.createdAt,
  });

  String get text {
    return '$operand1 ${moduleType.operator} $operand2 = ?';
  }
}
```

#### `lib/core/engines/question_engine/models/pattern_config.dart`
```dart
class PatternConfig {
  final String id;
  final int version;
  final ModuleType moduleType;
  final String name;
  final String description;
  final int difficulty;
  final int minValue;
  final int maxValue;
  final bool hasCarryOver;
  final int digitCount;
  final Map<String, dynamic>? metadata;

  PatternConfig({
    required this.id,
    required this.version,
    required this.moduleType,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.minValue,
    required this.maxValue,
    required this.hasCarryOver,
    required this.digitCount,
    this.metadata,
  });
}
```

### 9.2 Question Engine

#### `lib/core/engines/question_engine/question_engine.dart`
```dart
import 'dart:math';
import '../../database/app_database.dart';
import 'models/question.dart';
import 'models/module_type.dart';
import 'models/pattern_config.dart';

class QuestionEngine {
  final AppDatabase _database;
  final Random _random = Random();

  QuestionEngine(this._database);

  Future<Question> generateQuestion({
    required ModuleType moduleType,
    required String patternId,
  }) async {
    // Get pattern from database
    final pattern = await _database
        .select(_database.patterns)
        .get()
        .then((patterns) => patterns.firstWhere((p) => p.id == patternId));

    // Generate operands
    final operand1 = _generateOperand(
      pattern.minValue,
      pattern.maxValue,
    );
    final operand2 = _generateOperand(
      pattern.minValue,
      pattern.maxValue,
    );

    // Calculate answer
    final answer = _calculateAnswer(
      moduleType,
      operand1,
      operand2,
    );

    return Question(
      id: _generateQuestionId(),
      moduleType: moduleType,
      patternId: patternId,
      operand1: operand1,
      operand2: operand2,
      correctAnswer: answer,
      difficulty: pattern.difficulty,
      createdAt: DateTime.now(),
    );
  }

  bool checkAnswer({
    required Question question,
    required int userAnswer,
  }) {
    return question.correctAnswer == userAnswer;
  }

  int _generateOperand(int min, int max) {
    return min + _random.nextInt(max - min + 1);
  }

  int _calculateAnswer(ModuleType type, int op1, int op2) {
    switch (type) {
      case ModuleType.addition:
        return op1 + op2;
      case ModuleType.subtraction:
        return op1 - op2;
      case ModuleType.multiplication:
        return op1 * op2;
      case ModuleType.division:
        return op1 ~/ op2;
    }
  }

  String _generateQuestionId() {
    return 'q_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(1000)}';
  }
}
```

### 9.3 Provider

#### `lib/core/providers/engine_providers.dart`
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../engines/question_engine/question_engine.dart';
import 'database_provider.dart';

part 'engine_providers.g.dart';

@riverpod
QuestionEngine questionEngine(QuestionEngineRef ref) {
  return QuestionEngine(ref.watch(databaseProvider));
}
```

### Test Adımları (Bölüm 9)
1. Model ve engine dosyalarını oluştur
2. `build_runner` çalıştır
3. Test kodu yaz
4. Soru üretimini test et

---

## BÖLÜM 10: Addition Module - Pattern Data ve Seed

**Tahmini Süre:** 2 saat
**Test Noktası:** Toplama pattern'leri veritabanına yazılıyor

### 10.1 Addition Patterns

#### `lib/features/addition/data/addition_patterns.dart`
```dart
import '../../../core/engines/question_engine/models/module_type.dart';
import '../../../core/engines/question_engine/models/pattern_config.dart';

class AdditionPatterns {
  static List<PatternConfig> getAll() => [
    PatternConfig(
      id: 'add_single_digit',
      version: 1,
      moduleType: ModuleType.addition,
      name: 'Tek Basamak Toplama',
      description: '1-9 arası sayılarla toplama',
      difficulty: 1,
      minValue: 1,
      maxValue: 9,
      hasCarryOver: false,
      digitCount: 1,
      metadata: {
        'skill_level': 'beginner',
        'grade': '1',
      },
    ),
    PatternConfig(
      id: 'add_two_digit_no_carry',
      version: 1,
      moduleType: ModuleType.addition,
      name: 'İki Basamak (Eldesiz)',
      description: '10-99 arası eldeli toplama',
      difficulty: 2,
      minValue: 10,
      maxValue: 50,
      hasCarryOver: false,
      digitCount: 2,
      metadata: {
        'skill_level': 'intermediate',
        'grade': '2',
      },
    ),
    PatternConfig(
      id: 'add_two_digit_with_carry',
      version: 1,
      moduleType: ModuleType.addition,
      name: 'İki Basamak (Eldeli)',
      description: '10-99 arası eldeli toplama',
      difficulty: 3,
      minValue: 10,
      maxValue: 99,
      hasCarryOver: true,
      digitCount: 2,
      metadata: {
        'skill_level': 'intermediate',
        'grade': '2-3',
      },
    ),
    PatternConfig(
      id: 'add_three_digit',
      version: 1,
      moduleType: ModuleType.addition,
      name: 'Üç Basamak Toplama',
      description: '100-999 arası sayılarla toplama',
      difficulty: 4,
      minValue: 100,
      maxValue: 999,
      hasCarryOver: true,
      digitCount: 3,
      metadata: {
        'skill_level': 'advanced',
        'grade': '3-4',
      },
    ),
  ];
}
```

### 10.2 Pattern Seeder

#### `lib/core/database/seed/pattern_seeder.dart`
```dart
import '../../database/app_database.dart';
import '../../../features/addition/data/addition_patterns.dart';
import 'package:drift/drift.dart';

class PatternSeeder {
  final AppDatabase _database;

  PatternSeeder(this._database);

  Future<void> seedAll() async {
    await _seedAdditionPatterns();
    // Diğer modüller buraya eklenecek
  }

  Future<void> _seedAdditionPatterns() async {
    final patterns = AdditionPatterns.getAll();

    for (final pattern in patterns) {
      await _database.into(_database.patterns).insertOnConflictUpdate(
        PatternsCompanion(
          id: Value(pattern.id),
          version: Value(pattern.version),
          moduleType: Value(pattern.moduleType.name),
          name: Value(pattern.name),
          description: Value(pattern.description),
          difficulty: Value(pattern.difficulty),
          minValue: Value(pattern.minValue),
          maxValue: Value(pattern.maxValue),
          hasCarryOver: Value(pattern.hasCarryOver),
          digitCount: Value(pattern.digitCount),
          metadata: Value(pattern.metadata?.toString()),
        ),
      );
    }
  }
}
```

### 10.3 Seed at Startup

#### `lib/main.dart` güncellemesi
```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Database initialization
  final database = AppDatabase();
  final seeder = PatternSeeder(database);
  await seeder.seedAll();

  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}
```

### Test Adımları (Bölüm 10)
1. Pattern data dosyasını oluştur
2. Seeder'ı oluştur
3. Uygulamayı başlat
4. Veritabanında pattern'leri kontrol et

---

## BÖLÜM 11: Addition Module - Practice Screen

**Tahmini Süre:** 3-4 saat
**Test Noktası:** Toplama pratik modu çalışıyor

### 11.1 Practice State

#### `lib/features/addition/models/practice_state.dart`
```dart
import '../../../core/engines/question_engine/models/question.dart';

class PracticeState {
  final Question? currentQuestion;
  final int score;
  final int totalQuestions;
  final bool isCompleted;
  final int? userAnswer;
  final bool? wasCorrect;

  const PracticeState({
    this.currentQuestion,
    required this.score,
    required this.totalQuestions,
    required this.isCompleted,
    this.userAnswer,
    this.wasCorrect,
  });

  factory PracticeState.initial() {
    return const PracticeState(
      score: 0,
      totalQuestions: 0,
      isCompleted: false,
    );
  }

  PracticeState copyWith({
    Question? currentQuestion,
    int? score,
    int? totalQuestions,
    bool? isCompleted,
    int? userAnswer,
    bool? wasCorrect,
  }) {
    return PracticeState(
      currentQuestion: currentQuestion ?? this.currentQuestion,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      isCompleted: isCompleted ?? this.isCompleted,
      userAnswer: userAnswer ?? this.userAnswer,
      wasCorrect: wasCorrect ?? this.wasCorrect,
    );
  }
}
```

### 11.2 Practice Provider

#### `lib/features/addition/providers/addition_practice_provider.dart`
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/engine_providers.dart';
import '../../../core/engines/question_engine/models/module_type.dart';
import '../models/practice_state.dart';

part 'addition_practice_provider.g.dart';

@riverpod
class AdditionPractice extends _$AdditionPractice {
  @override
  FutureOr<PracticeState> build() async {
    return PracticeState.initial();
  }

  Future<void> startPractice() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final questionEngine = ref.read(questionEngineProvider);

      final question = await questionEngine.generateQuestion(
        moduleType: ModuleType.addition,
        patternId: 'add_single_digit',
      );

      return PracticeState.initial().copyWith(
        currentQuestion: question,
      );
    });
  }

  Future<void> submitAnswer(int answer) async {
    final currentState = state.value;
    if (currentState == null || currentState.currentQuestion == null) return;

    state = await AsyncValue.guard(() async {
      final questionEngine = ref.read(questionEngineProvider);

      final isCorrect = questionEngine.checkAnswer(
        question: currentState.currentQuestion!,
        userAnswer: answer,
      );

      // Generate next question
      final nextQuestion = await questionEngine.generateQuestion(
        moduleType: ModuleType.addition,
        patternId: 'add_single_digit',
      );

      return currentState.copyWith(
        currentQuestion: nextQuestion,
        score: isCorrect ? currentState.score + 1 : currentState.score,
        totalQuestions: currentState.totalQuestions + 1,
        userAnswer: answer,
        wasCorrect: isCorrect,
      );
    });
  }
}
```

### 11.3 Practice Screen

#### `lib/features/addition/screens/practice_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/feedback/success_feedback.dart';
import '../../../core/widgets/feedback/error_feedback.dart';
import '../../../core/l10n/app_localizations.dart';
import '../providers/addition_practice_provider.dart';

class AdditionPracticeScreen extends ConsumerStatefulWidget {
  const AdditionPracticeScreen({super.key});

  @override
  ConsumerState<AdditionPracticeScreen> createState() =>
      _AdditionPracticeScreenState();
}

class _AdditionPracticeScreenState
    extends ConsumerState<AdditionPracticeScreen> {
  final TextEditingController _answerController = TextEditingController();
  bool _showFeedback = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(additionPracticeProvider.notifier).startPractice();
    });
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final practiceState = ref.watch(additionPracticeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.moduleAddition),
        backgroundColor: AppColors.additionColor,
        foregroundColor: Colors.white,
      ),
      body: practiceState.when(
        data: (state) {
          if (_showFeedback) {
            return state.wasCorrect == true
                ? SuccessFeedback(
                    message: l10n.correctAnswer,
                    onComplete: _onFeedbackComplete,
                  )
                : ErrorFeedback(
                    message: l10n.wrongAnswer,
                    correctAnswer: l10n.correctAnswerWas(
                      state.currentQuestion?.correctAnswer ?? 0,
                    ),
                    onTryAgain: _onFeedbackComplete,
                  );
          }

          return _buildContent(context, state);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PracticeState state) {
    final l10n = AppLocalizations.of(context)!;

    if (state.currentQuestion == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.score(state.score),
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            state.currentQuestion!.text,
            style: AppTextStyles.question.copyWith(
              color: AppColors.additionColor,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          TextField(
            controller: _answerController,
            keyboardType: TextInputType.number,
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: '?',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.additionColor,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            text: l10n.commonContinue,
            backgroundColor: AppColors.additionColor,
            onPressed: _onSubmit,
          ),
        ],
      ),
    );
  }

  void _onSubmit() {
    final answer = int.tryParse(_answerController.text);
    if (answer == null) return;

    ref.read(additionPracticeProvider.notifier).submitAnswer(answer);
    setState(() {
      _showFeedback = true;
    });
  }

  void _onFeedbackComplete() {
    setState(() {
      _showFeedback = false;
      _answerController.clear();
    });
  }
}
```

### 11.4 Router Güncelleme

`lib/core/routing/app_router.dart`'a ekle:
```dart
GoRoute(
  path: RoutePaths.additionPractice,
  builder: (context, state) => const AdditionPracticeScreen(),
),
```

### Test Adımları (Bölüm 11)
1. Tüm dosyaları oluştur
2. `build_runner` çalıştır
3. Home'dan toplama modülüne git
4. Soru çöz ve feedback'i test et
5. Score'un arttığını kontrol et

---

## BÖLÜM 12-14: Diğer Modüller (Çıkarma, Çarpma, Bölme)

**Tahmini Süre:** 6-8 saat (her biri için 2-2.5 saat)
**Test Noktası:** Her modül bağımsız çalışıyor

Bu modüller Addition modülüyle aynı yapıda olacak:
- Pattern data dosyası
- Practice provider
- Practice screen
- Timed challenge screen (opsiyonel)

**Not:** Pattern'ler her modüle özel olacak (çıkarma için negatif sonuç kontrolü, bölme için tam bölünme kontrolü vb.)

---

## BÖLÜM 15: Supabase Integration

**Tahmini Süre:** 3-4 saat
**Test Noktası:** Veriler Supabase'e senkronize oluyor

### 15.1 Supabase Service

#### `lib/core/services/supabase_service.dart`
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  late final SupabaseClient _client;

  Future<void> initialize() async {
    await Supabase.initialize(
      url: 'YOUR_SUPABASE_URL',
      anonKey: 'YOUR_SUPABASE_ANON_KEY',
    );
    _client = Supabase.instance.client;
  }

  SupabaseClient get client => _client;

  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUp(String email, String password) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;
}
```

### 15.2 Sync Service

#### `lib/core/services/sync_service.dart`
```dart
import 'dart:async';
import 'dart:io';
import '../database/app_database.dart';
import 'supabase_service.dart';

class SyncService {
  final AppDatabase _database;
  final SupabaseService _supabase;
  Timer? _syncTimer;

  SyncService(this._database, this._supabase);

  Future<void> startAutoSync() async {
    _syncTimer = Timer.periodic(
      const Duration(minutes: 5),
      (timer) async {
        if (await _hasInternetConnection()) {
          await syncAll();
        }
      },
    );
  }

  void stopAutoSync() {
    _syncTimer?.cancel();
  }

  Future<void> syncAll() async {
    // TODO: Implement sync logic
    // Sync test sessions, results, analytics
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
```

### 15.3 Supabase Tables (SQL)

Supabase dashboard'da çalıştırılacak:

```sql
-- Students table
CREATE TABLE students (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  username TEXT NOT NULL UNIQUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_sync_at TIMESTAMP WITH TIME ZONE
);

-- Test Sessions table
CREATE TABLE test_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id UUID REFERENCES students(id),
  module_type TEXT NOT NULL,
  session_type TEXT NOT NULL,
  started_at TIMESTAMP WITH TIME ZONE,
  completed_at TIMESTAMP WITH TIME ZONE,
  total_questions INTEGER DEFAULT 0,
  correct_answers INTEGER DEFAULT 0,
  score INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Test Results table
CREATE TABLE test_results (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id UUID REFERENCES test_sessions(id),
  pattern_id TEXT,
  operand1 INTEGER,
  operand2 INTEGER,
  correct_answer INTEGER,
  user_answer INTEGER,
  is_correct BOOLEAN,
  response_time INTEGER,
  detected_error_type TEXT,
  answered_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_results ENABLE ROW LEVEL SECURITY;
```

### Test Adımları (Bölüm 15)
1. Supabase projesini oluştur
2. Tabloları oluştur
3. API keys'i .env'ye ekle
4. Sync service'i test et
5. Verilerin Supabase'e gittiğini kontrol et

---

## BÖLÜM 16: Analysis Engine

**Tahmini Süre:** 4-5 saat
**Test Noktası:** Öğrenci analizi çalışıyor

### 16.1 Analysis Models

#### `lib/core/engines/analysis_engine/models/student_analysis.dart`
```dart
class StudentAnalysis {
  final int studentId;
  final String moduleType;
  final Map<String, PatternPerformance> patternAnalysis;
  final Map<String, ErrorFrequency> errorAnalysis;
  final PerformanceMetrics metrics;
  final DateTime analyzedAt;

  StudentAnalysis({
    required this.studentId,
    required this.moduleType,
    required this.patternAnalysis,
    required this.errorAnalysis,
    required this.metrics,
    required this.analyzedAt,
  });

  List<String> get weakPatterns {
    return patternAnalysis.entries
        .where((e) => e.value.accuracy < 0.7)
        .map((e) => e.key)
        .toList();
  }
}

class PatternPerformance {
  final String patternId;
  final double accuracy;
  final int totalAttempts;
  final double averageTime;

  PatternPerformance({
    required this.patternId,
    required this.accuracy,
    required this.totalAttempts,
    required this.averageTime,
  });
}

class ErrorFrequency {
  final String errorTypeCode;
  final int frequency;
  final DateTime lastOccurrence;

  ErrorFrequency({
    required this.errorTypeCode,
    required this.frequency,
    required this.lastOccurrence,
  });
}

class PerformanceMetrics {
  final double overallAccuracy;
  final int totalQuestions;
  final int correctAnswers;
  final double averageResponseTime;

  PerformanceMetrics({
    required this.overallAccuracy,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.averageResponseTime,
  });
}
```

### 16.2 Analysis Engine

#### `lib/core/engines/analysis_engine/analysis_engine.dart`
```dart
import '../database/app_database.dart';
import 'models/student_analysis.dart';

class AnalysisEngine {
  final AppDatabase _database;

  AnalysisEngine(this._database);

  Future<StudentAnalysis> analyzeStudent({
    required int studentId,
    required String moduleType,
    int? lastNSessions,
  }) async {
    // TODO: Implement analysis logic
    // 1. Get test results
    // 2. Analyze patterns
    // 3. Analyze errors
    // 4. Calculate metrics
    // 5. Return analysis

    return StudentAnalysis(
      studentId: studentId,
      moduleType: moduleType,
      patternAnalysis: {},
      errorAnalysis: {},
      metrics: PerformanceMetrics(
        overallAccuracy: 0.0,
        totalQuestions: 0,
        correctAnswers: 0,
        averageResponseTime: 0.0,
      ),
      analyzedAt: DateTime.now(),
    );
  }
}
```

---

## BÖLÜM 17: Adaptive Engine

**Tahmini Süre:** 4-5 saat
**Test Noktası:** Adaptif soru üretimi çalışıyor

### 17.1 Adaptive Models

#### `lib/core/engines/adaptive_engine/models/adaptive_recommendations.dart`
```dart
class AdaptiveRecommendations {
  final int studentId;
  final String moduleType;
  final List<String> recommendedPatternIds;
  final Map<String, double> patternWeights;
  final int difficultyLevel;
  final DateTime generatedAt;

  AdaptiveRecommendations({
    required this.studentId,
    required this.moduleType,
    required this.recommendedPatternIds,
    required this.patternWeights,
    required this.difficultyLevel,
    required this.generatedAt,
  });
}
```

### 17.2 Adaptive Engine

#### `lib/core/engines/adaptive_engine/adaptive_engine.dart`
```dart
import '../database/app_database.dart';
import '../analysis_engine/analysis_engine.dart';
import 'models/adaptive_recommendations.dart';

class AdaptiveEngine {
  final AppDatabase _database;
  final AnalysisEngine _analysisEngine;

  AdaptiveEngine(this._database, this._analysisEngine);

  Future<AdaptiveRecommendations> getRecommendations({
    required int studentId,
    required String moduleType,
  }) async {
    // TODO: Implement adaptive logic
    // 1. Get or create analysis
    // 2. Generate pattern recommendations
    // 3. Calculate difficulty
    // 4. Return recommendations

    return AdaptiveRecommendations(
      studentId: studentId,
      moduleType: moduleType,
      recommendedPatternIds: ['add_single_digit'],
      patternWeights: {'add_single_digit': 1.0},
      difficultyLevel: 1,
      generatedAt: DateTime.now(),
    );
  }
}
```

---

## BÖLÜM 18: Profile ve Statistics Ekranı

**Tahmini Süre:** 3-4 saat
**Test Noktası:** İstatistikler görüntüleniyor

---

## BÖLÜM 19: Authentication

**Tahmini Süre:** 2-3 saat
**Test Noktası:** Giriş/Kayıt çalışıyor

---

## BÖLÜM 20: Final Testing ve Polish

**Tahmini Süre:** 4-6 saat
**Test Noktası:** Tüm özellikler sorunsuz çalışıyor

### 20.1 Test Checklist
- [ ] Tüm modüller çalışıyor
- [ ] Offline mod çalışıyor
- [ ] Senkronizasyon çalışıyor
- [ ] Dil değiştirme çalışıyor
- [ ] Animasyonlar akıcı
- [ ] Responsive tasarım test edildi
- [ ] Hata durumları handle ediliyor
- [ ] Loading state'ler doğru

### 20.2 Performance Optimization
- Database query optimization
- Widget rebuild optimization
- Image optimization
- Code splitting

### 20.3 Polish
- Ses efektleri (opsiyonel)
- Daha fazla animasyon
- Easter eggs
- Achievement sistem (opsiyonel)

---

## TOPLAM TAHMİNİ SÜRE

- **Temel Kurulum ve Core:** 15-20 saat
- **4 Matematik Modülü:** 12-16 saat
- **Engine Sistemleri:** 12-15 saat
- **Supabase ve Sync:** 4-6 saat
- **Auth ve Profile:** 5-7 saat
- **Testing ve Polish:** 6-10 saat

**TOPLAM:** 54-74 saat (7-10 iş günü)

---

## ÖNEMLİ NOTLAR

### Her Bölüm Sonrası
1. Kodu commit et
2. Test et
3. Hataları not al
4. Sonraki bölüme geç

### Git Workflow
```bash
# Her bölüm için
git add .
git commit -m "BÖLÜM X: [Açıklama]"
git push origin claude/explore-github-project-files-01Wrb7s2duDGoH3mKBmRwMrh
```

### Debugging
- Flutter DevTools kullan
- Database'i SQLite Viewer ile kontrol et
- Riverpod Inspector kullan
- Hot reload/restart farkını bil

### Best Practices
- Her zaman `const` kullan (mümkünse)
- Widget'ları küçük tut (< 300 satır)
- Stateless > Stateful (mümkünse)
- Riverpod provider'ları küçük tut
- Her feature bağımsız olmalı

---

## NASIL KULLANILACAK

1. **Sırayla ilerle:** Bölüm 1'den başla, sırayla git
2. **Test et:** Her bölüm sonunda test et
3. **Commit et:** Her bölüm sonunda commit et
4. **Geri bildir:** Hata varsa not al, devam et
5. **Sorma:** Ben zaten ne yapacağımı biliyorum, sen sadece hataları bildir

Bu yol haritası ile projeyi eksiksiz, modüler ve test edilebilir şekilde geliştirebiliriz!
