import 'dart:convert';
import 'package:flutter/services.dart';
import '../interfaces/questionnaire_config_service.dart';
import '../../models/questionnaire_config.dart';
import '../../models/branding_config.dart';

/// Implementation of QuestionnaireConfigService for testing mode
/// Loads configuration from local JSON assets
class QuestionnaireConfigServiceImpl implements QuestionnaireConfigService {
  static const String _questionnaireConfigPath = 'assets/questionnaire_config.json';
  static const String _brandingConfigPath = 'assets/branding_config.json';

  @override
  Future<QuestionnaireConfig> loadQuestionnaireConfig() async {
    try {
      // Load JSON from assets
      final jsonString = await rootBundle.loadString(_questionnaireConfigPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;

      // Parse and validate
      final config = QuestionnaireConfig.fromJson(jsonData);

      if (!validateConfig(config)) {
        throw Exception('Invalid questionnaire configuration');
      }

      return config;
    } catch (e) {
      throw Exception('Failed to load questionnaire config: $e');
    }
  }

  @override
  Future<BrandingConfig> loadBrandingConfig() async {
    try {
      // Load JSON from assets
      final jsonString = await rootBundle.loadString(_brandingConfigPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;

      // Parse branding config
      final config = BrandingConfig.fromJson(jsonData);

      return config;
    } catch (e) {
      // Return default branding if loading fails
      return const BrandingConfig(
        title: 'NutriWell Clinic',
        subtitle: 'Dr. Sarah Johnson',
        logoUrl: '',
        nutritionistName: 'Dr. Sarah Johnson',
        primaryColor: '#2196F3',
        secondaryColor: '#4CAF50',
      );
    }
  }

  @override
  bool validateConfig(QuestionnaireConfig config) {
    // Basic validation checks
    if (config.sections.isEmpty) {
      return false;
    }

    // Check each section has questions
    for (final section in config.sections) {
      if (section.questions.isEmpty) {
        return false;
      }

      // Check for unique question IDs within section
      final questionIds = section.questions.map((q) => q.id).toSet();
      if (questionIds.length != section.questions.length) {
        return false; // Duplicate question IDs
      }

      // TODO: Add conditional logic validation when implemented
      // Check conditional logic references valid questions
      // for (final question in section.questions) {
      //   if (question.conditionalLogic != null) {
      //     final dependsOnId = question.conditionalLogic!.dependsOnQuestionId;
      //     bool found = false;
      //
      //     // Check if referenced question exists in any section
      //     for (final checkSection in config.sections) {
      //       if (checkSection.questions.any((q) => q.id == dependsOnId)) {
      //         found = true;
      //         break;
      //       }
      //     }
      //
      //     if (!found) {
      //       return false; // Invalid conditional logic reference
      //     }
      //   }
      // }
    }

    // Check for unique section IDs
    final sectionIds = config.sections.map((s) => s.id).toSet();
    if (sectionIds.length != config.sections.length) {
      return false; // Duplicate section IDs
    }

    return true;
  }
}