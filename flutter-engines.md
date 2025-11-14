# Flutter Engine System Rules

## Engine System Overview

The app is built on 3 main engines:

1. **Question Engine** - Question generation engine
2. **Analysis Engine** - Data analysis engine
3. **Adaptive Engine** - Adaptive learning engine

**Core Principle:** Engines are shared across all modules. Each engine is module-agnostic (independent of modules).

## Engine Location

**Location:** `core/engines/`

```
core/engines/
├── question_engine/
│   ├── question_engine.dart
│   └── models/
│       ├── question.dart
│       ├── question_request.dart
│       └── pattern_config.dart
│
├── analysis_engine/
│   ├── analysis_engine.dart
│   └── models/
│       ├── student_analysis.dart
│       ├── performance_metrics.dart
│       └── error_analysis.dart
│
└── adaptive_engine/
    ├── adaptive_engine.dart
    └── models/
        ├── learning_profile.dart
        ├── difficulty_adjustment.dart
        └── adaptive_recommendations.dart
```

## Question Engine

### Responsibilities

1. Generates questions based on patterns and error types
2. Uses recommendations from adaptive engine
3. Performs mathematical calculations
4. Checks answers

### Usage

```dart
class QuestionEngine {
  final AppDatabase _database;
  
  QuestionEngine(this._database);
  
  /// Generates a new question based on recommendations
  Future<Question> generateQuestion({
    required ModuleType moduleType,
    required AdaptiveRecommendations recommendations,
  }) async {
    // 1. Get recommended patterns
    final patterns = await _getPatterns(
      moduleType: moduleType,
      patternIds: recommendations.recommendedPatternIds,
    );
    
    // 2. Select pattern (weighted random)
    final selectedPattern = _selectPattern(
      patterns: patterns,
      weights: recommendations.patternWeights,
    );
    
    // 3. Select error type (if any)
    final errorType = _selectErrorType(
      errorTypes: recommendations.targetErrorTypes,
    );
    
    // 4. Generate question
    return _generateQuestionFromPattern(
      pattern: selectedPattern,
      errorType: errorType,
    );
  }
  
  /// Checks if answer is correct
  bool checkAnswer({
    required Question question,
    required int userAnswer,
  }) {
    return question.correctAnswer == userAnswer;
  }
  
  /// Generates wrong answer based on common error type
  int generateDistractorAnswer({
    required Question question,
    required ErrorType errorType,
  }) {
    // Generate typical wrong answer based on error type
    switch (errorType.code) {
      case 'carry_over_error':
        return _generateCarryOverError(question);
      case 'digit_reversal':
        return _generateDigitReversalError(question);
      default:
        return question.correctAnswer + 1;
    }
  }
}
```

### Question Model

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
  
  /// Returns question text (e.g., "25 + 17 = ?")
  String get text {
    final operator = _getOperator(moduleType);
    return '$operand1 $operator $operand2 = ?';
  }
  
  String _getOperator(ModuleType type) {
    switch (type) {
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

## Analysis Engine

### Responsibilities

1. Analyzes student's historical data
2. Identifies strengths/weaknesses
3. Finds patterns where student struggles
4. Detects frequent errors
5. Saves analysis results to database

### Usage

```dart
class AnalysisEngine {
  final AppDatabase _database;
  
  AnalysisEngine(this._database);
  
  /// Analyzes student's performance in a specific module
  Future<StudentAnalysis> analyzeStudent({
    required int studentId,
    required ModuleType moduleType,
    int? lastNSessions, // Last N sessions (null = all)
  }) async {
    // 1. Get test results
    final results = await _database.testResultsDao.getResults(
      studentId: studentId,
      moduleType: moduleType,
      limit: lastNSessions,
    );
    
    // 2. Pattern-based analysis
    final patternAnalysis = await _analyzePatterns(results);
    
    // 3. Error type analysis
    final errorAnalysis = await _analyzeErrors(results);
    
    // 4. Time analysis
    final timeAnalysis = _analyzeResponseTimes(results);
    
    // 5. General metrics
    final metrics = _calculateMetrics(results);
    
    // 6. Create analysis result
    final analysis = StudentAnalysis(
      studentId: studentId,
      moduleType: moduleType,
      patternAnalysis: patternAnalysis,
      errorAnalysis: errorAnalysis,
      timeAnalysis: timeAnalysis,
      metrics: metrics,
      analyzedAt: DateTime.now(),
    );
    
    // 7. Save to database
    await _database.studentAnalyticsDao.saveAnalysis(analysis);
    
    return analysis;
  }
  
  /// Pattern-based performance analysis
  Future<Map<String, PatternPerformance>> _analyzePatterns(
    List<TestResult> results,
  ) async {
    final patternPerformance = <String, PatternPerformance>{};
    
    // For each pattern
    for (final patternId in results.map((r) => r.patternId).toSet()) {
      final patternResults = results.where((r) => r.patternId == patternId);
      
      final correctCount = patternResults.where((r) => r.isCorrect).length;
      final totalCount = patternResults.length;
      final avgTime = patternResults
          .map((r) => r.responseTime)
          .reduce((a, b) => a + b) / totalCount;
      
      patternPerformance[patternId] = PatternPerformance(
        patternId: patternId,
        accuracy: correctCount / totalCount,
        averageTime: avgTime,
        totalAttempts: totalCount,
        needsImprovement: correctCount / totalCount < 0.7, // Below 70%
      );
    }
    
    return patternPerformance;
  }
  
  /// Error type analysis
  Future<Map<String, ErrorFrequency>> _analyzeErrors(
    List<TestResult> results,
  ) async {
    final errorFrequency = <String, ErrorFrequency>{};
    
    // Analyze only incorrect answers
    final incorrectResults = results.where((r) => !r.isCorrect);
    
    for (final result in incorrectResults) {
      // Detect error type from wrong answer
      final detectedError = await _detectErrorType(result);
      
      if (detectedError != null) {
        errorFrequency[detectedError.code] = ErrorFrequency(
          errorTypeCode: detectedError.code,
          frequency: (errorFrequency[detectedError.code]?.frequency ?? 0) + 1,
          lastOccurrence: result.answeredAt,
        );
      }
    }
    
    return errorFrequency;
  }
}
```

### StudentAnalysis Model

```dart
class StudentAnalysis {
  final int studentId;
  final ModuleType moduleType;
  final Map<String, PatternPerformance> patternAnalysis;
  final Map<String, ErrorFrequency> errorAnalysis;
  final TimeAnalysis timeAnalysis;
  final PerformanceMetrics metrics;
  final DateTime analyzedAt;
  
  StudentAnalysis({
    required this.studentId,
    required this.moduleType,
    required this.patternAnalysis,
    required this.errorAnalysis,
    required this.timeAnalysis,
    required this.metrics,
    required this.analyzedAt,
  });
  
  /// Patterns where student is weak
  List<String> get weakPatterns {
    return patternAnalysis.entries
        .where((e) => e.value.needsImprovement)
        .map((e) => e.key)
        .toList();
  }
  
  /// Most frequent errors
  List<String> get frequentErrors {
    return errorAnalysis.entries
        .where((e) => e.value.frequency > 3)
        .map((e) => e.key)
        .toList();
  }
}
```

## Adaptive Engine

### Responsibilities

1. Uses data from analysis engine
2. Selects patterns suitable for student's level
3. Determines which error types to test
4. Adjusts difficulty level
5. Generates recommendations for question engine

### Usage

```dart
class AdaptiveEngine {
  final AppDatabase _database;
  final AnalysisEngine _analysisEngine;
  
  AdaptiveEngine(this._database, this._analysisEngine);
  
  /// Generates adaptive recommendations for student
  Future<AdaptiveRecommendations> getRecommendations({
    required int studentId,
    required ModuleType moduleType,
  }) async {
    // 1. Get latest analysis (or create new if none)
    var analysis = await _database.studentAnalyticsDao.getLatestAnalysis(
      studentId: studentId,
      moduleType: moduleType,
    );
    
    if (analysis == null || _isAnalysisStale(analysis)) {
      analysis = await _analysisEngine.analyzeStudent(
        studentId: studentId,
        moduleType: moduleType,
      );
    }
    
    // 2. Generate pattern recommendations
    final patternRecommendations = _generatePatternRecommendations(analysis);
    
    // 3. Generate error type recommendations
    final errorRecommendations = _generateErrorRecommendations(analysis);
    
    // 4. Difficulty adjustment
    final difficultyAdjustment = _calculateDifficultyAdjustment(analysis);
    
    return AdaptiveRecommendations(
      studentId: studentId,
      moduleType: moduleType,
      recommendedPatternIds: patternRecommendations.patternIds,
      patternWeights: patternRecommendations.weights,
      targetErrorTypes: errorRecommendations,
      difficultyLevel: difficultyAdjustment.currentLevel,
      focusAreas: _identifyFocusAreas(analysis),
      generatedAt: DateTime.now(),
    );
  }
  
  /// Generate pattern recommendations
  PatternRecommendations _generatePatternRecommendations(
    StudentAnalysis analysis,
  ) {
    final recommendations = <String, double>{};
    
    // More weight to weak patterns
    for (final weakPattern in analysis.weakPatterns) {
      recommendations[weakPattern] = 0.4; // 40% weight
    }
    
    // Medium level patterns
    final mediumPatterns = analysis.patternAnalysis.entries
        .where((e) => e.value.accuracy >= 0.7 && e.value.accuracy < 0.9)
        .map((e) => e.key);
    
    for (final pattern in mediumPatterns) {
      recommendations[pattern] = 0.3; // 30% weight
    }
    
    // Strong patterns (for reinforcement)
    final strongPatterns = analysis.patternAnalysis.entries
        .where((e) => e.value.accuracy >= 0.9)
        .map((e) => e.key);
    
    for (final pattern in strongPatterns) {
      recommendations[pattern] = 0.1; // 10% weight
    }
    
    // Untried patterns
    // TODO: Get all patterns from database and find untried ones
    
    return PatternRecommendations(
      patternIds: recommendations.keys.toList(),
      weights: recommendations,
    );
  }
  
  /// Generate error type recommendations
  List<String> _generateErrorRecommendations(StudentAnalysis analysis) {
    // Target 3 most frequent errors
    return analysis.frequentErrors.take(3).toList();
  }
  
  /// Difficulty level adjustment
  DifficultyAdjustment _calculateDifficultyAdjustment(
    StudentAnalysis analysis,
  ) {
    final accuracy = analysis.metrics.overallAccuracy;
    final avgTime = analysis.timeAnalysis.averageResponseTime;
    
    int currentLevel;
    
    if (accuracy >= 0.9 && avgTime < 5000) {
      // Excellent performance - increase difficulty
      currentLevel = (analysis.metrics.currentDifficulty + 1).clamp(1, 5);
    } else if (accuracy < 0.6) {
      // Weak performance - decrease difficulty
      currentLevel = (analysis.metrics.currentDifficulty - 1).clamp(1, 5);
    } else {
      // Normal performance - stay at same level
      currentLevel = analysis.metrics.currentDifficulty;
    }
    
    return DifficultyAdjustment(
      currentLevel: currentLevel,
      reason: _getDifficultyReason(accuracy, avgTime),
    );
  }
  
  bool _isAnalysisStale(StudentAnalysis analysis) {
    // Analysis older than 24 hours is stale
    return DateTime.now().difference(analysis.analyzedAt).inHours > 24;
  }
}
```

### AdaptiveRecommendations Model

```dart
class AdaptiveRecommendations {
  final int studentId;
  final ModuleType moduleType;
  final List<String> recommendedPatternIds;
  final Map<String, double> patternWeights; // Pattern ID -> Weight (0-1)
  final List<String> targetErrorTypes;
  final int difficultyLevel; // 1-5
  final List<String> focusAreas;
  final DateTime generatedAt;
  
  AdaptiveRecommendations({
    required this.studentId,
    required this.moduleType,
    required this.recommendedPatternIds,
    required this.patternWeights,
    required this.targetErrorTypes,
    required this.difficultyLevel,
    required this.focusAreas,
    required this.generatedAt,
  });
}
```

## Pattern and Error Type Definitions

### Pattern Definition Format

**Location:** `features/{module}/data/{module}_patterns.dart`

```dart
class AdditionPatterns {
  static List<PatternConfig> getAll() => [
    PatternConfig(
      id: 'add_single_digit',
      version: 1,
      moduleType: ModuleType.addition,
      name: 'Single Digit Addition',
      description: 'Addition with numbers 1-9',
      difficulty: 1,
      minValue: 1,
      maxValue: 9,
      hasCarryOver: false,
      digitCount: 1,
      metadata: {
        'skill_level': 'beginner',
        'grade': '1-2',
      },
    ),
    PatternConfig(
      id: 'add_two_digit_with_carry',
      version: 1,
      moduleType: ModuleType.addition,
      name: 'Two Digit Addition with Carry',
      description: '10-99 addition with carry',
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
  ];
}
```

### Error Type Definition Format

**Location:** `features/{module}/data/{module}_errors.dart`

```dart
class AdditionErrors {
  static List<ErrorTypeConfig> getAll() => [
    ErrorTypeConfig(
      code: 'carry_over_error',
      name: 'Carry Error',
      description: 'Forgetting or incorrect carry in addition',
      moduleType: ModuleType.addition,
      severity: ErrorSeverity.high,
      detectionPattern: (question, userAnswer) {
        // Check for forgotten carry
        final correctAnswer = question.correctAnswer;
        final difference = (correctAnswer - userAnswer).abs();
        return difference == 10 || difference == 100;
      },
    ),
    ErrorTypeConfig(
      code: 'digit_reversal',
      name: 'Digit Reversal',
      description: 'Writing result backwards (e.g., 42 instead of 24)',
      moduleType: ModuleType.addition,
      severity: ErrorSeverity.medium,
      detectionPattern: (question, userAnswer) {
        // Check for digit reversal
        final correctAnswer = question.correctAnswer;
        final reversed = _reverseDigits(correctAnswer);
        return userAnswer == reversed;
      },
    ),
  ];
}
```

## Engine Integration

### Using in Providers

```dart
@riverpod
class AdditionPractice extends _$AdditionPractice {
  late final QuestionEngine _questionEngine;
  late final AdaptiveEngine _adaptiveEngine;
  late final AnalysisEngine _analysisEngine;
  
  @override
  FutureOr<PracticeState> build() async {
    // Get engine instances
    _questionEngine = ref.watch(questionEngineProvider);
    _adaptiveEngine = ref.watch(adaptiveEngineProvider);
    _analysisEngine = ref.watch(analysisEngineProvider);
    
    return PracticeState.initial();
  }
  
  Future<void> startPractice() async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      // 1. Get recommendations from adaptive engine
      final recommendations = await _adaptiveEngine.getRecommendations(
        studentId: 1, // TODO: Current student
        moduleType: ModuleType.addition,
      );
      
      // 2. Generate question with question engine
      final question = await _questionEngine.generateQuestion(
        moduleType: ModuleType.addition,
        recommendations: recommendations,
      );
      
      return PracticeState.initial().copyWith(
        currentQuestion: question,
      );
    });
  }
  
  Future<void> submitAnswer(int answer) async {
    final currentState = state.value;
    if (currentState == null) return;
    
    state = await AsyncValue.guard(() async {
      final question = currentState.currentQuestion!;
      
      // 1. Check answer
      final isCorrect = _questionEngine.checkAnswer(
        question: question,
        userAnswer: answer,
      );
      
      // 2. Save to database
      await _saveResult(question, answer, isCorrect);
      
      // 3. Generate new question
      final recommendations = await _adaptiveEngine.getRecommendations(
        studentId: 1,
        moduleType: ModuleType.addition,
      );
      
      final nextQuestion = await _questionEngine.generateQuestion(
        moduleType: ModuleType.addition,
        recommendations: recommendations,
      );
      
      return currentState.copyWith(
        currentQuestion: nextQuestion,
        score: isCorrect ? currentState.score + 1 : currentState.score,
        totalQuestions: currentState.totalQuestions + 1,
      );
    });
  }
}
```

## Engine Best Practices

1. **Engines should be stateless**
   - State stored in database
   - Engine only does calculations

2. **Use dependency injection**
   - Database and other services injected via constructor
   - Increases testability

3. **Async operations**
   - All engine methods async
   - Database read/write async

4. **Error handling**
   - Engine methods can throw exceptions
   - Handle at provider level

5. **Performance**
   - Heavy calculations can be done in isolate
   - Can use cache (like pattern list)

6. **Logging**
   - Log engine decisions
   - Important for debugging

## Engine Testing (Manual Test Notes)

When testing engine system:

1. **Question Engine:**
   - Generates questions from correct pattern?
   - Answer checking works correctly?
   - Difficulty levels correct?

2. **Analysis Engine:**
   - Correctly identifies weak patterns?
   - Error type detection works?
   - Analysis results make sense?

3. **Adaptive Engine:**
   - Recommendations suitable for student level?
   - Difficulty adjustment works?
   - Focuses on weak areas?

4. **Integration:**
   - 3 engines work together?
   - Data flow correct?
   - Performance issues?
