# Math Master App

A Flutter-based math education app for children aged 7-10.

## Features

- 4 Math Modules: Addition, Subtraction, Multiplication, Division
- Offline-First with Supabase Sync
- 3 Engine System: Question, Analysis, Adaptive
- Multi-language Support (Turkish, English)
- Child-Friendly UI/UX

## Getting Started

### Prerequisites

- Flutter SDK 3.16.0 or higher
- Dart SDK 3.2.0 or higher
- Supabase Account (for cloud sync)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/pipks/frontendMathApp.git
cd frontendMathApp
```

2. Install dependencies:
```bash
flutter pub get
```

3. Create `.env` file (copy from `.env.example`):
```bash
cp .env.example .env
```

4. Add your Supabase credentials to `.env`:
```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

5. Generate code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

6. Generate localizations:
```bash
flutter gen-l10n
```

7. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/               # Shared code
│   ├── theme/         # Colors, text styles, theme config
│   ├── widgets/       # Reusable widgets
│   ├── routing/       # GoRouter configuration
│   ├── database/      # Drift database
│   ├── services/      # Services (Supabase, Sync)
│   ├── l10n/          # Localization files
│   ├── engines/       # 3 main engines
│   └── providers/     # Global providers
├── features/          # Feature modules
│   ├── auth/
│   ├── onboarding/
│   ├── home/
│   ├── profile/
│   ├── addition/
│   ├── subtraction/
│   ├── multiplication/
│   └── division/
└── main.dart
```

## Development Roadmap

See [ROADMAP.md](ROADMAP.md) for detailed development plan.

## Documentation

- [Architecture](flutter-architecture.md)
- [Database & Sync](flutter-database-sync.md)
- [Engine System](flutter-engines.md)
- [Internationalization](flutter-i18n.md)
- [State Management](flutter-state-management.md)
- [UI Standards](flutter-ui-standards.md)

## License

See [LICENSE](LICENSE) file for details.
