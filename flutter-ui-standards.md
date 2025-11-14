# Flutter UI and Theme Standards

## Target Audience

**Children aged 7-10**

Design decisions based on this age group's needs:
- Large, easy-to-touch elements
- Bright, fun colors
- Large, readable fonts
- Abundant visual feedback
- Simple, clear interface

## Material 3 Usage

**Material 3** as base, customized for children.

**Why Material 3?**
- Modern, ready components
- Accessibility support
- Easy customization
- Consistent design system

## Color Palette

### Main Colors

**Location:** `core/theme/app_colors.dart`

```dart
class AppColors {
  // Primary - Blue (Trust, learning)
  static const primary = Color(0xFF2196F3);
  static const primaryLight = Color(0xFF64B5F6);
  static const primaryDark = Color(0xFF1976D2);
  
  // Secondary - Orange (Energy, excitement)
  static const secondary = Color(0xFFFF9800);
  static const secondaryLight = Color(0xFFFFB74D);
  static const secondaryDark = Color(0xFFF57C00);
  
  // Success - Green (Correct answer)
  static const success = Color(0xFF4CAF50);
  static const successLight = Color(0xFF81C784);
  
  // Error - Red (Wrong answer)
  static const error = Color(0xFFF44336);
  static const errorLight = Color(0xFFE57373);
  
  // Warning - Yellow (Attention)
  static const warning = Color(0xFFFFC107);
  
  // Module Colors
  static const additionColor = Color(0xFF2196F3);      // Blue
  static const subtractionColor = Color(0xFFE91E63);   // Pink
  static const multiplicationColor = Color(0xFF9C27B0); // Purple
  static const divisionColor = Color(0xFF4CAF50);      // Green
  
  // Neutral
  static const background = Color(0xFFF5F5F5);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
  static const divider = Color(0xFFBDBDBD);
}
```

**Color Usage Rules:**
1. **Success feedback:** Green (`success`)
2. **Error feedback:** Red (`error`)
3. **Buttons:** Primary or secondary
4. **Module cards:** Use module color
5. **Background:** Light gray (`background`)

### Color Accessibility

- Contrast ratio minimum 4.5:1 (WCAG AA)
- Color-blind friendly palette
- Don't rely on color alone (icon + color)

## Typography

### Font Sizes

**Location:** `core/theme/app_text_styles.dart`

```dart
class AppTextStyles {
  // Headings - Very large
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
  
  // Body - Large and readable
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
  
  // Question text - Very large
  static const question = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  // Button text - Large
  static const button = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
  
  // Small text (use carefully)
  static const caption = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );
}
```

**Typography Rules:**
1. **Minimum font size:** 16sp
2. **Headings:** 24sp and above
3. **Question texts:** 48sp (very large)
4. **Button texts:** 20sp
5. **Line height:** 1.4-1.5 (for readability)

### Font Family

```dart
static const fontFamily = 'Poppins'; // Rounded, friendly
// Alternative: 'Quicksand', 'Nunito'
```

**Font Characteristics:**
- Rounded corners
- Friendly appearance
- Readable for children
- Strong bold variants

## Spacing and Layout

### Spacing System

```dart
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}
```

**Spacing Rules:**
1. **Between widgets:** `md` (16)
2. **Between sections:** `lg` (24)
3. **Page padding:** `lg` (24)
4. **Card inner padding:** `md` (16)

### Touch Target Sizes

**Minimum touch area:** 60x60 (large for children)

```dart
class AppSizes {
  // Buttons
  static const buttonHeight = 60.0;
  static const buttonMinWidth = 120.0;
  
  // Cards
  static const cardMinHeight = 100.0;
  static const cardBorderRadius = 16.0;
  
  // Icons
  static const iconSmall = 24.0;
  static const iconMedium = 32.0;
  static const iconLarge = 48.0;
  
  // Module cards
  static const moduleCardHeight = 140.0;
  static const moduleCardWidth = 160.0;
}
```

## Widget Standards

### Buttons

**Location:** `core/widgets/buttons/`

**Primary Button:**
```dart
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  
  const PrimaryButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 32),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(text, style: AppTextStyles.button),
      ),
    );
  }
}
```

**Button Rules:**
1. Minimum height: 60px
2. Rounded corners: 16px radius
3. Padding: 32px horizontal
4. Show loading state
5. Disabled state should be clear

### Cards

**Location:** `core/widgets/cards/`

**Module Card:**
```dart
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

**Card Rules:**
1. Rounded corners: 16px
2. Elevation: 2-4
3. Padding: 16px
4. Gradient background (for module cards)
5. Ripple effect (InkWell)

### Feedback Widgets

**Location:** `core/widgets/feedback/`

**Success Animation:**
```dart
class SuccessFeedback extends StatelessWidget {
  final VoidCallback onComplete;
  
  const SuccessFeedback({required this.onComplete, super.key});
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      color: AppColors.success.withOpacity(0.9),
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
              l10n.correctAnswer,
              style: AppTextStyles.h1.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Feedback Rules:**
1. Full screen overlay
2. Large icon (120px)
3. Clear message (localized)
4. Show 2-3 seconds (for success)
5. Manual continue (for error)
6. Add sound effect (optional)

## Animations

### Animation Durations

```dart
class AppAnimations {
  static const fast = Duration(milliseconds: 200);
  static const normal = Duration(milliseconds: 300);
  static const slow = Duration(milliseconds: 500);
}
```

### Animation Rules

1. **Button press:** Scale animation (0.95)
2. **Page transition:** Slide animation
3. **Feedback:** Fade + Scale
4. **Loading:** Circular progress
5. **Success:** Confetti or checkmark animation

**Example:**
```dart
AnimatedScale(
  scale: isPressed ? 0.95 : 1.0,
  duration: AppAnimations.fast,
  child: button,
)
```

## Theme Configuration

**Location:** `core/theme/app_theme.dart`

```dart
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
      
      // Text theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.h1,
        displayMedium: AppTextStyles.h2,
        displaySmall: AppTextStyles.h3,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        labelLarge: AppTextStyles.button,
      ),
      
      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
      ),
      
      // Card theme
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Input decoration theme
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

## Accessibility

### Semantics

Add semantics for interactive widgets:

```dart
Semantics(
  label: l10n.moduleAddition,
  hint: l10n.tapToStartAddition,
  button: true,
  child: ModuleCard(...),
)
```

### Contrast

- Text and background contrast ratio: 4.5:1
- Large text (18sp+): 3:1
- Test with: Chrome DevTools Accessibility

### Font Scaling

Support system font size:

```dart
Text(
  l10n.title,
  style: AppTextStyles.h1,
  // textScaleFactor automatically applied
)
```

## Responsive Design

### Breakpoints

```dart
class AppBreakpoints {
  static const mobile = 600.0;
  static const tablet = 900.0;
}
```

### Layout Rules

1. **Mobile (< 600px):** Single column
2. **Tablet (600-900px):** Two columns
3. **Padding:** Adjust based on screen size

```dart
double getResponsivePadding(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < AppBreakpoints.mobile) return AppSpacing.md;
  if (width < AppBreakpoints.tablet) return AppSpacing.lg;
  return AppSpacing.xl;
}
```

## UI Best Practices

1. **Consistency:** Use same components
2. **Feedback:** Give feedback for every interaction
3. **Loading states:** Show loading for async operations
4. **Error states:** Show errors clearly
5. **Empty states:** Show empty states nicely
6. **Child-friendly:** Large, colorful, fun
7. **Performance:** Target 60 FPS
8. **Test:** Test on real devices
9. **Localization:** All text must be localized
