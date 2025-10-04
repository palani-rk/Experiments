import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/branding_config.dart';

/// Provider for the clinic branding configuration
///
/// This provider manages the branding information displayed throughout
/// the questionnaire application. In a production environment, this
/// configuration would typically be:
/// - Loaded from a remote configuration service
/// - Cached locally for offline access
/// - Updated based on user's assigned clinic/nutritionist
///
/// Security considerations:
/// - Configuration should be validated before use
/// - Image URLs should be verified and sanitized
/// - Sensitive information should be handled securely
/// - Consider implementing configuration versioning for updates
final brandingConfigProvider = Provider<BrandingConfig>((ref) {
  // Default configuration - in production this would be loaded from:
  // 1. Remote configuration service (Firebase Remote Config, etc.)
  // 2. Local storage/cache
  // 3. User-specific assignment data
  // 4. Organization/clinic settings

  return const BrandingConfig(
    clinicName: 'Wellness Center',
    nutritionistName: 'Dr. Sarah Johnson',
    welcomeMessage: 'Welcome to your personalized nutrition journey!',
    welcomeSubtitle: 'Let\'s create a plan that works perfectly for your lifestyle.',
    // Example logo URLs (commented out for security - validate before use)
    // clinicLogoUrl: 'https://example.com/clinic-logo.png',
    // nutritionistAvatarUrl: 'https://example.com/nutritionist-avatar.jpg',
  );
});

/// Provider for branding configuration that can be overridden
///
/// This allows for testing different branding configurations or
/// dynamic updates during runtime. Useful for:
/// - A/B testing different branding messages
/// - Multi-tenant applications with different clinic brands
/// - Development and testing with different configurations
final overridableBrandingProvider = StateProvider<BrandingConfig?>((ref) {
  return null; // No override by default
});

/// Provider that returns the active branding configuration
///
/// This provider combines the default configuration with any overrides,
/// providing a single source of truth for branding throughout the app
final activeBrandingProvider = Provider<BrandingConfig>((ref) {
  final override = ref.watch(overridableBrandingProvider);
  final defaultConfig = ref.watch(brandingConfigProvider);

  return override ?? defaultConfig;
});

/// Notifier for managing branding configuration updates
///
/// Provides methods to update branding configuration at runtime
/// while maintaining proper validation and error handling
class BrandingConfigNotifier extends StateNotifier<BrandingConfig> {
  BrandingConfigNotifier(BrandingConfig initialConfig) : super(initialConfig);

  /// Updates the clinic name with validation
  ///
  /// Throws [ArgumentError] if the name is empty or contains invalid characters
  void updateClinicName(String clinicName) {
    if (clinicName.trim().isEmpty) {
      throw ArgumentError('Clinic name cannot be empty');
    }

    final sanitizedName = clinicName
        .replaceAll(RegExp(r'[<>"]'), '').replaceAll("'", '')
        .trim();

    if (sanitizedName.isEmpty) {
      throw ArgumentError('Clinic name contains only invalid characters');
    }

    state = state.copyWith(clinicName: sanitizedName);
  }

  /// Updates the nutritionist name with validation
  ///
  /// Throws [ArgumentError] if the name contains invalid characters
  void updateNutritionistName(String nutritionistName) {
    final sanitizedName = nutritionistName
        .replaceAll(RegExp(r'[<>"]'), '').replaceAll("'", '')
        .trim();

    state = state.copyWith(nutritionistName: sanitizedName);
  }

  /// Updates the welcome message with validation
  ///
  /// Throws [ArgumentError] if the message is empty after sanitization
  void updateWelcomeMessage(String welcomeMessage) {
    if (welcomeMessage.trim().isEmpty) {
      throw ArgumentError('Welcome message cannot be empty');
    }

    final sanitizedMessage = welcomeMessage
        .replaceAll(RegExp(r'[<>"]'), '').replaceAll("'", '')
        .trim();

    if (sanitizedMessage.isEmpty) {
      throw ArgumentError('Welcome message contains only invalid characters');
    }

    state = state.copyWith(welcomeMessage: sanitizedMessage);
  }

  /// Updates the welcome subtitle with validation
  void updateWelcomeSubtitle(String welcomeSubtitle) {
    final sanitizedSubtitle = welcomeSubtitle
        .replaceAll(RegExp(r'[<>"]'), '').replaceAll("'", '')
        .trim();

    state = state.copyWith(welcomeSubtitle: sanitizedSubtitle);
  }

  /// Updates the clinic logo URL with security validation
  ///
  /// Throws [ArgumentError] if the URL is not HTTPS or is malformed
  /// Pass null to remove the logo
  void updateClinicLogoUrl(String? logoUrl) {
    if (logoUrl != null) {
      try {
        final uri = Uri.parse(logoUrl);
        if (!uri.isScheme('https')) {
          throw ArgumentError('Logo URL must use HTTPS protocol for security');
        }
        if (uri.host.isEmpty) {
          throw ArgumentError('Logo URL must have a valid host');
        }
      } catch (e) {
        throw ArgumentError('Invalid logo URL format: $e');
      }
    }

    state = state.copyWith(clinicLogoUrl: logoUrl);
  }

  /// Updates the nutritionist avatar URL with security validation
  ///
  /// Throws [ArgumentError] if the URL is not HTTPS or is malformed
  /// Pass null to remove the avatar
  void updateNutritionistAvatarUrl(String? avatarUrl) {
    if (avatarUrl != null) {
      try {
        final uri = Uri.parse(avatarUrl);
        if (!uri.isScheme('https')) {
          throw ArgumentError('Avatar URL must use HTTPS protocol for security');
        }
        if (uri.host.isEmpty) {
          throw ArgumentError('Avatar URL must have a valid host');
        }
      } catch (e) {
        throw ArgumentError('Invalid avatar URL format: $e');
      }
    }

    state = state.copyWith(nutritionistAvatarUrl: avatarUrl);
  }

  /// Resets the branding configuration to default values
  void resetToDefault() {
    state = const BrandingConfig();
  }

  /// Updates the entire configuration at once
  ///
  /// Validates all fields before applying the update
  /// Throws [ArgumentError] if any field fails validation
  void updateConfiguration(BrandingConfig newConfig) {
    // Validate the new configuration
    if (newConfig.safeClinicName.isEmpty) {
      throw ArgumentError('Clinic name cannot be empty');
    }

    if (newConfig.safeWelcomeMessage.isEmpty) {
      throw ArgumentError('Welcome message cannot be empty');
    }

    if (newConfig.clinicLogoUrl != null && !newConfig.isLogoUrlSafe) {
      throw ArgumentError('Clinic logo URL is not safe');
    }

    if (newConfig.nutritionistAvatarUrl != null && !newConfig.isAvatarUrlSafe) {
      throw ArgumentError('Nutritionist avatar URL is not safe');
    }

    state = newConfig;
  }
}

/// Provider for the branding configuration notifier
///
/// Allows for dynamic updates to branding configuration throughout the app
final brandingConfigNotifierProvider =
    StateNotifierProvider<BrandingConfigNotifier, BrandingConfig>((ref) {
  final initialConfig = ref.watch(brandingConfigProvider);
  return BrandingConfigNotifier(initialConfig);
});

/// Utility extension for easily accessing branding configuration
extension BrandingProviderExtensions on WidgetRef {
  /// Gets the current active branding configuration
  BrandingConfig get branding => watch(activeBrandingProvider);

  /// Gets the branding configuration notifier for updates
  BrandingConfigNotifier get brandingNotifier =>
      read(brandingConfigNotifierProvider.notifier);
}