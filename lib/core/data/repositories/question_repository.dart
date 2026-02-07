import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../models/question_model.dart';

class QuestionRepository {
  // Cache to store loaded questions
  final Map<String, List<QuestionModel>> _questionsCache = {};

  // Mapping of category IDs to JSON file names
  final Map<String, Map<String, String>> _categoryFileMap = {
    'classic': {
      'en': 'assets/questions/Classic/en_classic.json',
      'es': 'assets/questions/Classic/es_classic.json',
      'de': 'assets/questions/Classic/de_classic.json',
      'fr': 'assets/questions/Classic/fr_classic.json',
      'ko': 'assets/questions/Classic/ko_classic.json',
    },
    'party': {
      'en': 'assets/questions/party-vibe-check/party_vibe_en.json',
      'es': 'assets/questions/party-vibe-check/party_vibe_es.json',
      'de': 'assets/questions/party-vibe-check/party_vibe_de.json',
      'fr': 'assets/questions/party-vibe-check/party_vibe_fr.json',
      'ko': 'assets/questions/party-vibe-check/party_vibe_ko.json',
    },
    'girls': {
      'en': 'assets/questions/girls only/girls_only_en.json',
      'es': 'assets/questions/girls only/girls_only_es.json',
      'de': 'assets/questions/girls only/girls_only_de.json',
      'fr': 'assets/questions/girls only/girls_only_fr.json',
      'ko': 'assets/questions/girls only/girls_only_ko.json',
    },
    'couples': {
      'en': 'assets/questions/Сouple/couples_en.json',
      'es': 'assets/questions/Сouple/couples_es.json',
      'de': 'assets/questions/Сouple/couples_de.json',
      'fr': 'assets/questions/Сouple/couples_fr.json',
      'ko': 'assets/questions/Сouple/couples_ko.json',
    },
    'hot': {
      'en': 'assets/questions/hot-spicy/hot_spicy_en.json',
      'es': 'assets/questions/hot-spicy/hot_spicy_es.json',
      'de': 'assets/questions/hot-spicy/hot_spicy_de.json',
      'fr': 'assets/questions/hot-spicy/hot_spicy_fr.json',
      'ko': 'assets/questions/hot-spicy/hot_spicy_ko.json',
    },
    'guys': {
      'en': 'assets/questions/bros only/bros_only_en.json',
      'es': 'assets/questions/bros only/bros_only_es.json',
      'de': 'assets/questions/bros only/bros_only_de.json',
      'fr': 'assets/questions/bros only/bros_only_fr.json',
      'ko': 'assets/questions/bros only/bros_only_ko.json',
    },
  };

  /// Load questions from JSON file based on category ID and language
  /// Returns cached questions if already loaded
  Future<List<QuestionModel>> loadQuestions(
    String categoryId,
    String languageCode,
  ) async {
    // Create cache key
    final cacheKey = '${categoryId}_$languageCode';

    // Return cached questions if available
    if (_questionsCache.containsKey(cacheKey)) {
      return _questionsCache[cacheKey]!;
    }

    try {
      // Get file path from mapping
      final categoryFiles = _categoryFileMap[categoryId];
      if (categoryFiles == null) {
        throw Exception('Unknown category: $categoryId');
      }

      final filePath = categoryFiles[languageCode];
      if (filePath == null) {
        // Fallback to English if language not available
        final fallbackPath = categoryFiles['en'];
        if (fallbackPath == null) {
          throw Exception('No questions available for category: $categoryId');
        }
        return loadQuestions(categoryId, 'en');
      }

      // Load JSON file from assets
      final jsonString = await rootBundle.loadString(filePath);
      final jsonData = json.decode(jsonString);

      // Parse questions
      List<QuestionModel> questions = [];
      if (jsonData is List) {
        // Direct array format
        questions = jsonData
            .map((item) => QuestionModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (jsonData is Map) {
        // Object format - check for common keys
        List<dynamic>? questionsData;

        // Try common question key patterns
        if (jsonData.containsKey('questions')) {
          questionsData = jsonData['questions'] as List;
        } else if (jsonData.containsKey('classic_mode')) {
          questionsData = jsonData['classic_mode'] as List;
        } else if (jsonData.containsKey('party_vibe_pack')) {
          questionsData = jsonData['party_vibe_pack'] as List;
        } else {
          // Get the first array value from the map
          final firstValue = jsonData.values.firstWhere(
            (value) => value is List,
            orElse: () => <dynamic>[],
          );
          if (firstValue is List) {
            questionsData = firstValue;
          }
        }

        if (questionsData != null) {
          questions = questionsData
              .map((item) => QuestionModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }

      // Cache the questions
      _questionsCache[cacheKey] = questions;

      return questions;
    } catch (e) {
      throw Exception('Failed to load questions: $e');
    }
  }

  /// Shuffle questions randomly
  List<QuestionModel> shuffleQuestions(List<QuestionModel> questions) {
    final shuffled = List<QuestionModel>.from(questions);
    shuffled.shuffle(Random());
    return shuffled;
  }

  /// Clear cache for a specific category and language
  void clearCache(String categoryId, String languageCode) {
    final cacheKey = '${categoryId}_$languageCode';
    _questionsCache.remove(cacheKey);
  }

  /// Clear all cached questions
  void clearAllCache() {
    _questionsCache.clear();
  }
}
