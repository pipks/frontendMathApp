# Flutter Architecture Rules

## About the Project

This is a math education app developed for children aged 7-10. The app contains 4 core math modules (addition, subtraction, multiplication, division) and each module can be developed independently.

## Core Architecture Approach

**Feature-First + Simplified Clean Architecture**

- Modular structure: Each feature can be developed independently
- Prevents code duplication
- Clear structure suitable for AI assistant collaboration
- Pragmatic approach instead of complex layers

## Folder Structure

```
lib/
├── core/                    # Shared code for all modules
│   ├── theme/              # Theme, colors, text styles
│   ├── widgets/            # Shared widgets
│   ├── routing/            # GoRouter configuration
│   ├── database/           # Drift setup and tables
│   ├── services/           # Supabase, sync services
│   ├── l10n/               # Localization files
│   └── engines/            # 3 main engines (Question, Analysis, Adaptive)
│
├── features/               # Feature-based modules
│   ├── auth/              # Authentication
│   ├── onboarding/        # Welcome and introduction
│   ├── home/              # Home page
│   ├── profile/           # Profile and statistics
│   ├── addition/          # Addition module
│   ├── subtraction/       # Subtraction module
│   ├── multiplication/    # Multiplication module
│   └── division/          # Division module
│
└── main.dart
```

## Core Folder Rules

### `core/theme/`
- All theme definitions here
- Child-friendly color palette
- Large, readable font definitions
- Material 3 theme configuration

**Files:**
- `app_colors.dart` - Color constants
- `app_text_styles.dart` - Text style definitions
- `app_theme.dart` - Main theme config

### `core/widgets/`
- Shared widgets used across all modules
- Organized with subfolders

**Subfolders:**
- `buttons/` - Button widgets
- `cards/` - Card widgets
- `feedback/` - Animation and feedback widgets
- `layouts/` - Layout widgets

### `core/routing/`
- GoRouter configuration
- Route definitions
- Navigation guards

**Files:**
- `app_router.dart` - Main router config

### `core/database/`
- Drift database setup
- Table definitions
- Seed logic

**Subfolders:**
- `tables/` - All table definitions
- `seed/` - Database seed logic

**Files:**
- `app_database.dart` - Main database setup

### `core/services/`
- Supabase connection service
- Offline-online sync service
- Other global services

### `core/l10n/`
- Localization files (ARB format)
- Translation strings for all supported languages
- Generated localization classes

**Files:**
- `app_en.arb` - English translations
- `app_tr.arb` - Turkish translations
- `app_localizations.dart` - Generated (do not edit manually)

### `core/engines/`
- 3 main engines: Question Engine, Analysis Engine, Adaptive Engine
- Shared across all modules
- Each engine in its own subfolder

**Structure:**
```
engines/
├── question_engine/
│   ├── question_engine.dart
│   └── models/
├── analysis_engine/
│   ├── analysis_engine.dart
│   └── models/
└── adaptive_engine/
    ├── adaptive_engine.dart
    └── models/
```

## Features Folder Rules

### Adding a New Feature

When adding a new feature, create a folder under `features/` with the feature name.

**Standard feature structure:**
```
features/{feature_name}/
├── models/          # Data models
├── providers/       # Riverpod providers
├── screens/         # Page widgets
└── widgets/         # Feature-specific widgets
```

### Adding a Math Module

When adding a new math module (e.g., exponents, fractions):

**Required structure:**
```
features/{module_name}/
├── data/                           # Pattern and error definitions
│   ├── {module_name}_patterns.dart
│   └── {module_name}_errors.dart
├── models/                         # Data models
├── providers/                      # State management
├── screens/                        # Pages
│   ├── {module_name}_menu_screen.dart
│   ├── practice_screen.dart
│   └── timed_challenge_screen.dart
└── widgets/                        # Module-specific widgets
```

**Rules:**
- Each module must be completely independent
- Deleting a module should not affect other modules
- Shared code must be in `core/`
- Module-specific code stays in its own folder

### Feature Folder Details

#### `models/`
- Data models and entities
- Freezed can be used (optional)
- JSON serialization if needed

#### `providers/`
- Riverpod provider definitions
- Separate provider for each screen
- Use AsyncNotifierProvider

#### `screens/`
- Full page widgets
- One screen per file
- File name: `{screen_name}_screen.dart`

#### `widgets/`
- Feature-specific, reusable widgets
- Used only within this feature
- Move to `core/widgets/` if used in multiple features

#### `data/` (Math modules only)
- Pattern definitions
- Error type definitions
- Seeded to database on app startup

## Module Independence Principles

1. **A module should not import another module**
   - ❌ Don't import `features/subtraction/` from `features/addition/`
   - ✅ Move shared code to `core/`

2. **Each module manages its own state**
   - Each module has its own providers
   - Global state only in `core/`

3. **Shared widgets in `core/widgets/`**
   - Move widgets to core if used in multiple modules
   - Module-specific widgets stay in their folder

4. **Database tables are module-agnostic**
   - Tables in `core/database/tables/`
   - Modules use tables but don't own them

## File Organization Rules

1. **Each file should have a single responsibility**
   - One screen or one widget per file
   - Multiple related models can be in the same file

2. **File size should not exceed 300 lines**
   - Split if longer
   - Move widgets to separate files

3. **Import ordering:**
   ```dart
   // 1. Dart core
   import 'dart:async';
   
   // 2. Flutter
   import 'package:flutter/material.dart';
   
   // 3. External packages
   import 'package:riverpod/riverpod.dart';
   import 'package:go_router/go_router.dart';
   
   // 4. Internal - core
   import 'package:app/core/theme/app_colors.dart';
   
   // 5. Internal - features
   import 'package:app/features/addition/models/question.dart';
   ```

## New Feature Checklist

When adding a new feature:

- [ ] Create feature folder under `features/`
- [ ] Create standard subfolders (models, providers, screens, widgets)
- [ ] Add route to router (`core/routing/app_router.dart`)
- [ ] Add database table if needed (`core/database/tables/`)
- [ ] Add shared widgets to `core/widgets/` if applicable
- [ ] Add localization strings to ARB files
- [ ] Test that feature works independently

## Math Module Checklist

When adding a new math module:

- [ ] Create `features/{module_name}/` folder
- [ ] Create pattern and error files in `data/` folder
- [ ] Add patterns to database seed
- [ ] Create menu, practice and timed challenge screens
- [ ] Add module card to home page
- [ ] Add module routes to router
- [ ] Add module-specific translations to ARB files
- [ ] Test that module works independently
