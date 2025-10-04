import 'package:flutter/material.dart';
import '../../data/models/branding_config.dart';
import '../../../../shared/theme/app_theme.dart';

/// Displays clinic branding information at the top of screens
///
/// Features:
/// - Clinic logo (optional, with fallback to icon)
/// - Clinic name display
/// - Nutritionist name with title
/// - Consistent styling and spacing
/// - Theme-aware colors and typography
/// - Proper error handling for image loading
/// - Security validation for image URLs
///
/// Security considerations:
/// - URLs are validated before loading images
/// - Fallback icon is used for failed/invalid URLs
/// - Text content is sanitized through BrandingConfig getters
class BrandingHeader extends StatelessWidget {
  /// The branding configuration containing clinic and nutritionist information
  final BrandingConfig branding;

  /// Whether to show the nutritionist name below the clinic name
  final bool showNutritionist;

  /// Optional custom height for the header (defaults to 80)
  final double? height;

  /// Creates a [BrandingHeader] widget
  ///
  /// [branding] - Required branding configuration
  /// [showNutritionist] - Whether to display nutritionist information
  /// [height] - Custom height for the header component
  const BrandingHeader({
    super.key,
    required this.branding,
    this.showNutritionist = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height ?? 80,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.l,
        vertical: AppSizes.m,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Clinic Logo or Fallback Icon
          _buildLogo(context),

          const SizedBox(width: AppSizes.m),

          // Clinic and Nutritionist Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  branding.safeClinicName,
                  style: AppTextStyles.headerSubtitle.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (showNutritionist && branding.safeNutritionistName.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'with ${branding.safeNutritionistName}',
                    style: AppTextStyles.progressLabel.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the logo widget with proper error handling and security validation
  ///
  /// Returns either a network image (if valid URL) or a fallback icon
  Widget _buildLogo(BuildContext context) {
    final theme = Theme.of(context);

    // Check if we have a valid and safe logo URL
    if (branding.clinicLogoUrl != null && branding.isLogoUrlSafe) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          child: Image.network(
            branding.clinicLogoUrl!,
            fit: BoxFit.cover,
            // Loading placeholder
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _buildLoadingPlaceholder(context);
            },
            // Error fallback
            errorBuilder: (context, error, stackTrace) {
              // Log error for debugging (in production, use proper logging)
              debugPrint('BrandingHeader: Failed to load logo from ${branding.clinicLogoUrl}: $error');
              return _buildFallbackIcon(context);
            },
            // Network-specific configuration
            headers: {
              'User-Agent': 'NutriApp/1.0.0', // Identify our app
            },
          ),
        ),
      );
    }

    // Use fallback icon if no URL or invalid URL
    return _buildFallbackIcon(context);
  }

  /// Builds a loading placeholder for the logo
  Widget _buildLoadingPlaceholder(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the fallback icon when no logo is available or loading fails
  Widget _buildFallbackIcon(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: Icon(
        Icons.local_hospital,
        size: 32,
        color: theme.colorScheme.onPrimaryContainer,
      ),
    );
  }
}

/// Extension methods for BrandingHeader-specific functionality
extension BrandingHeaderExtensions on BrandingConfig {
  /// Returns true if the branding configuration is complete enough for display
  bool get isValidForDisplay {
    return safeClinicName.isNotEmpty || safeNutritionistName.isNotEmpty;
  }

  /// Returns a short display name combining clinic and nutritionist
  String get shortDisplayName {
    if (safeClinicName.isNotEmpty && safeNutritionistName.isNotEmpty) {
      return '$safeClinicName - $safeNutritionistName';
    }
    return safeClinicName.isNotEmpty ? safeClinicName : safeNutritionistName;
  }
}