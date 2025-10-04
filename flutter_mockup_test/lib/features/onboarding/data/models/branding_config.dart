import 'package:freezed_annotation/freezed_annotation.dart';

part 'branding_config.freezed.dart';
part 'branding_config.g.dart';

/// Configuration for clinic branding displayed throughout the questionnaire
///
/// Contains information about the clinic, nutritionist, and personalized messages
/// that provide a branded experience for users during onboarding.
///
/// Security Considerations:
/// - Clinic logo URLs should be validated to prevent XSS attacks
/// - Messages should be sanitized to prevent injection attacks
/// - Personal information should be handled according to privacy policies
@freezed
class BrandingConfig with _$BrandingConfig {
  /// Creates a [BrandingConfig] with clinic and nutritionist information
  ///
  /// [clinicName] - The name of the healthcare clinic or practice
  /// [nutritionistName] - The name of the assigned nutritionist/dietitian
  /// [clinicLogoUrl] - Optional URL to the clinic's logo image
  /// [nutritionistAvatarUrl] - Optional URL to the nutritionist's profile image
  /// [welcomeMessage] - Personalized welcome message displayed to users
  /// [welcomeSubtitle] - Supporting text that provides additional context
  const factory BrandingConfig({
    /// The name of the healthcare clinic or practice
    @Default('NutriApp') String clinicName,

    /// The name of the assigned nutritionist or dietitian
    @Default('Dr. Smith') String nutritionistName,

    /// Optional URL to the clinic's logo image
    /// Should be validated for security before use
    String? clinicLogoUrl,

    /// Optional URL to the nutritionist's profile photo
    /// Should be validated for security before use
    String? nutritionistAvatarUrl,

    /// Personalized welcome message displayed on the welcome screen
    @Default('Welcome to your personalized nutrition journey!')
    String welcomeMessage,

    /// Supporting text that provides additional context or encouragement
    @Default('We\'re excited to help you achieve your health goals.')
    String welcomeSubtitle,
  }) = _BrandingConfig;

  /// Creates a [BrandingConfig] from JSON data
  ///
  /// Throws [FormatException] if the JSON structure is invalid
  /// Throws [TypeError] if required fields have incorrect types
  factory BrandingConfig.fromJson(Map<String, dynamic> json) =>
      _$BrandingConfigFromJson(json);

  const BrandingConfig._();

  /// Validates if the clinic logo URL is safe to use
  ///
  /// Returns true if the URL is null (no logo) or passes basic security checks
  /// This is a basic validation - production apps should implement more robust
  /// URL validation including domain whitelisting and content type checking
  bool get isLogoUrlSafe {
    if (clinicLogoUrl == null) return true;

    try {
      final uri = Uri.parse(clinicLogoUrl!);
      // Basic validation: must be HTTPS and have a valid scheme
      return uri.hasScheme &&
             uri.isScheme('https') &&
             uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Validates if the nutritionist avatar URL is safe to use
  ///
  /// Returns true if the URL is null (no avatar) or passes basic security checks
  bool get isAvatarUrlSafe {
    if (nutritionistAvatarUrl == null) return true;

    try {
      final uri = Uri.parse(nutritionistAvatarUrl!);
      // Basic validation: must be HTTPS and have a valid scheme
      return uri.hasScheme &&
             uri.isScheme('https') &&
             uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Returns a sanitized clinic name safe for display
  ///
  /// Removes potentially dangerous characters while preserving readability
  String get safeClinicName {
    return clinicName
        .replaceAll(RegExp(r'[<>"]'), '').replaceAll("'", '')
        .trim();
  }

  /// Returns a sanitized nutritionist name safe for display
  ///
  /// Removes potentially dangerous characters while preserving readability
  String get safeNutritionistName {
    return nutritionistName
        .replaceAll(RegExp(r'[<>"]'), '').replaceAll("'", '')
        .trim();
  }

  /// Returns a sanitized welcome message safe for display
  ///
  /// Removes potentially dangerous characters while preserving readability
  String get safeWelcomeMessage {
    return welcomeMessage
        .replaceAll(RegExp(r'[<>"]'), '').replaceAll("'", '')
        .trim();
  }

  /// Returns a sanitized welcome subtitle safe for display
  ///
  /// Removes potentially dangerous characters while preserving readability
  String get safeWelcomeSubtitle {
    return welcomeSubtitle
        .replaceAll(RegExp(r'[<>"]'), '').replaceAll("'", '')
        .trim();
  }
}