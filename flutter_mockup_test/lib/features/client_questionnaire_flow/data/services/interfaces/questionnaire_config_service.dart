import '../../models/questionnaire_config.dart';
import '../../models/branding_config.dart';

/// Service interface for loading questionnaire configuration
/// Supports different modes: testing (local JSON) and production (API)
abstract class QuestionnaireConfigService {
  /// Load the complete questionnaire configuration
  /// In testing mode: loads from local JSON assets
  /// In production mode: loads from remote API
  Future<QuestionnaireConfig> loadQuestionnaireConfig();

  /// Load branding configuration for the clinic
  /// Used to customize the UI appearance and messaging
  Future<BrandingConfig> loadBrandingConfig();

  /// Validate questionnaire configuration integrity
  /// Ensures all questions have valid sections, required fields, etc.
  bool validateConfig(QuestionnaireConfig config);
}