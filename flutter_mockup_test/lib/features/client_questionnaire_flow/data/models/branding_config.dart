import 'package:freezed_annotation/freezed_annotation.dart';

part 'branding_config.freezed.dart';
part 'branding_config.g.dart';

/// Branding configuration for clinic customization
@freezed
class BrandingConfig with _$BrandingConfig {
  const factory BrandingConfig({
    required String logoUrl,
    required String title,
    required String subtitle,
    String? nutritionistName,
    String? clientName,
    @Default('#6d5e0f') String primaryColor,
    @Default('#43664e') String secondaryColor,
  }) = _BrandingConfig;

  factory BrandingConfig.fromJson(Map<String, dynamic> json) =>
      _$BrandingConfigFromJson(json);
}

/// Extension methods for BrandingConfig - Pure data access only
extension BrandingConfigExtension on BrandingConfig {
  /// Gets the effective title to display
  String get effectiveTitle {
    if (clientName != null && clientName!.isNotEmpty) {
      return 'Welcome, $clientName!';
    }
    return title;
  }

  /// Gets the effective subtitle to display
  String get effectiveSubtitle {
    if (nutritionistName != null && nutritionistName!.isNotEmpty) {
      return 'with $nutritionistName';
    }
    return subtitle;
  }
}