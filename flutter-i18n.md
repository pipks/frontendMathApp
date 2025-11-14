# Flutter Internationalization (i18n) Rules

## Overview

The app supports multiple languages using Flutter's built-in localization system with ARB (Application Resource Bundle) files.

**Supported Languages:**
- Turkish (tr) - Primary language
- English (en) - Secondary language
- Additional languages can be added easily

## Setup

### Dependencies

Add to `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: any

flutter:
  generate: true
```

### Configuration

Create `l10n.yaml` in project root:
```yaml
arb-dir: lib/core/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

## ARB Files Location

**Location:** `core/l10n/`

```
core/l10n/
├── app_en.arb    # English translations
├── app_tr.arb    # Turkish translations
└── app_localizations.dart  # Generated (don't edit)
```

## ARB File Format

### English Template (`app_en.arb`)

```json
{
  "@@locale": "en",
  
  "appTitle": "Math Master",
  "@appTitle": {
    "description": "The title of the application"
  },
  
  "welcome": "Welcome!",
  "@welcome": {
    "description": "Welcome message on onboarding screen"
  },
  
  "moduleAddition": "Addition",
  "@moduleAddition": {
    "description": "Addition module name"
  },
  
  "moduleSubtraction": "Subtraction",
  "moduleMultiplication": "Multiplication",
  "moduleDivision": "Division",
  
  "practiceMode": "Practice Mode",
  "timedChallenge": "Timed Challenge",
  
  "correctAnswer": "Correct! 🎉",
  "wrongAnswer": "Oops! Try again",
  "correctAnswerWas": "The correct answer was: {answer}",
  "@correctAnswerWas": {
    "description": "Shows the correct answer after wrong attempt",
    "placeholders": {
      "answer": {
        "type": "int",
        "example": "42"
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
  
  "questionsCompleted": "You completed {count} {count, plural, =1{question} other{questions}}!",
  "@questionsCompleted": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

### Turkish Translations (`app_tr.arb`)

```json
{
  "@@locale": "tr",
  
  "appTitle": "Matematik Ustası",
  "welcome": "Hoş Geldin!",
  
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
  
  "questionsCompleted": "{count} {count, plural, =1{soru} other{soru}} tamamladın!"
}
```

## Usage in Code

### Setup in main.dart

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:math_app/core/l10n/app_localizations.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Localization delegates
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // Supported locales
      supportedLocales: const [
        Locale('en'), // English
        Locale('tr'), // Turkish
      ],
      
      // Default locale
      locale: const Locale('tr'),
      
      // Router config
      routerConfig: appRouter,
      
      // Theme
      theme: AppTheme.lightTheme,
    );
  }
}
```

### Using Translations in Widgets

```dart
import 'package:flutter/material.dart';
import 'package:math_app/core/l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get localization instance
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              l10n.welcome,
              style: AppTextStyles.h1,
            ),
            
            // With parameters
            Text(l10n.score(42)),
            
            // With plurals
            Text(l10n.questionsCompleted(5)),
          ],
        ),
      ),
    );
  }
}
```

### Using in Providers

```dart
@riverpod
class AdditionPractice extends _$AdditionPractice {
  @override
  FutureOr<PracticeState> build() async {
    // Providers don't have direct access to context
    // Pass localized strings from UI layer
    return PracticeState.initial();
  }
  
  // Or use a localization service
  String getLocalizedMessage(String key) {
    // Implement localization service
    return LocalizationService.instance.translate(key);
  }
}
```

## Translation Keys Organization

### Naming Convention

Use dot notation for hierarchical organization:

```json
{
  "common.ok": "OK",
  "common.cancel": "Cancel",
  "common.save": "Save",
  "common.delete": "Delete",
  
  "auth.login": "Login",
  "auth.register": "Register",
  "auth.logout": "Logout",
  
  "home.title": "Home",
  "home.selectModule": "Select a module",
  
  "addition.title": "Addition",
  "addition.practice": "Practice Addition",
  "addition.timed": "Timed Addition Challenge",
  
  "feedback.correct": "Correct! 🎉",
  "feedback.incorrect": "Try again!",
  "feedback.excellent": "Excellent!",
  "feedback.goodJob": "Good job!",
  
  "errors.networkError": "Network error. Please check your connection.",
  "errors.unknownError": "An unknown error occurred."
}
```

### Categories

**Common:**
- `common.*` - Buttons, actions, general UI

**Features:**
- `auth.*` - Authentication related
- `home.*` - Home screen
- `profile.*` - Profile and statistics
- `addition.*` - Addition module
- `subtraction.*` - Subtraction module
- `multiplication.*` - Multiplication module
- `division.*` - Division module

**Feedback:**
- `feedback.*` - Success/error messages, encouragement

**Errors:**
- `errors.*` - Error messages

## Best Practices

### 1. Always Use Localization

**❌ Wrong:**
```dart
Text('Welcome!')
```

**✅ Correct:**
```dart
Text(AppLocalizations.of(context)!.welcome)
```

### 2. Extract All User-Facing Strings

All strings shown to users must be in ARB files:
- Button labels
- Screen titles
- Messages
- Error messages
- Feedback messages
- Placeholder text

### 3. Don't Localize

These should NOT be localized:
- API endpoints
- Database keys
- Log messages (for debugging)
- Technical error codes
- Configuration values

### 4. Use Placeholders for Dynamic Content

**❌ Wrong:**
```dart
Text('Score: $score')
```

**✅ Correct:**
```json
{
  "score": "Score: {score}"
}
```

```dart
Text(l10n.score(score))
```

### 5. Use Plurals Correctly

```json
{
  "questionsCompleted": "{count} {count, plural, =0{questions} =1{question} other{questions}} completed"
}
```

### 6. Context in Descriptions

Always add `@` descriptions for translators:

```json
{
  "submit": "Submit",
  "@submit": {
    "description": "Button label to submit an answer"
  }
}
```

### 7. Keep Keys Consistent

Use the same key structure across all language files.

## Language Switching

### Provider for Locale

```dart
// core/providers/locale_provider.dart
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    // Load from shared preferences or use system locale
    return const Locale('tr');
  }
  
  void setLocale(Locale locale) {
    state = locale;
    // Save to shared preferences
  }
  
  void toggleLanguage() {
    state = state.languageCode == 'tr' 
        ? const Locale('en') 
        : const Locale('tr');
  }
}
```

### Using in MaterialApp

```dart
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeNotifierProvider);
    
    return MaterialApp.router(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
    );
  }
}
```

### Language Selector Widget

```dart
class LanguageSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeNotifierProvider);
    
    return DropdownButton<Locale>(
      value: currentLocale,
      items: const [
        DropdownMenuItem(
          value: Locale('tr'),
          child: Text('🇹🇷 Türkçe'),
        ),
        DropdownMenuItem(
          value: Locale('en'),
          child: Text('🇬🇧 English'),
        ),
      ],
      onChanged: (locale) {
        if (locale != null) {
          ref.read(localeNotifierProvider.notifier).setLocale(locale);
        }
      },
    );
  }
}
```

## Testing Translations

### Manual Testing

1. **Switch language in app**
   - Test all screens in both languages
   - Check for text overflow
   - Verify plurals work correctly

2. **Check for missing translations**
   - Run app in each language
   - Look for missing keys (shows key name instead of translation)

3. **Test with long text**
   - Some languages have longer words
   - Ensure UI doesn't break

### Automated Checks

```dart
// Test that all keys exist in all languages
void main() {
  test('All translation keys exist in all languages', () {
    final enKeys = loadARB('app_en.arb').keys;
    final trKeys = loadARB('app_tr.arb').keys;
    
    expect(enKeys, equals(trKeys));
  });
}
```

## Adding a New Language

1. **Create new ARB file:**
   - `core/l10n/app_es.arb` (for Spanish)

2. **Copy English template:**
   - Copy all keys from `app_en.arb`
   - Translate values

3. **Add to supported locales:**
   ```dart
   supportedLocales: const [
     Locale('en'),
     Locale('tr'),
     Locale('es'), // New language
   ],
   ```

4. **Run code generation:**
   ```bash
   flutter gen-l10n
   ```

5. **Test the new language**

## Code Generation

After modifying ARB files, run:

```bash
flutter gen-l10n
```

This generates:
- `app_localizations.dart`
- `app_localizations_en.dart`
- `app_localizations_tr.dart`

**Never edit generated files manually!**

## Common Patterns

### Date and Time Formatting

```dart
import 'package:intl/intl.dart';

final dateFormat = DateFormat.yMMMd(l10n.localeName);
final formattedDate = dateFormat.format(DateTime.now());
```

### Number Formatting

```dart
import 'package:intl/intl.dart';

final numberFormat = NumberFormat.decimalPattern(l10n.localeName);
final formattedNumber = numberFormat.format(1234.56);
```

### Currency (if needed)

```dart
final currencyFormat = NumberFormat.currency(
  locale: l10n.localeName,
  symbol: '₺',
);
```

## Localization Checklist

When adding a new feature:

- [ ] Add all user-facing strings to ARB files
- [ ] Add translations for all supported languages
- [ ] Add `@` descriptions for context
- [ ] Use placeholders for dynamic content
- [ ] Use plurals where appropriate
- [ ] Test in all languages
- [ ] Check for text overflow
- [ ] Run `flutter gen-l10n`
- [ ] Verify generated files compile

## Resources

- [Flutter Internationalization Guide](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- [ARB Format Specification](https://github.com/google/app-resource-bundle)
- [Intl Package](https://pub.dev/packages/intl)
