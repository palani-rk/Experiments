import 'package:flutter/material.dart';
import '../../data/models/branding_config.dart';
import '../../../../shared/theme/app_theme.dart';

/// Reusable branding header widget - Phase 3: Dynamic implementation
/// Connected to BrandingConfig for dynamic configuration
class BrandingHeader extends StatelessWidget {
  final bool showSubtitle;
  final BrandingConfig? brandingConfig;

  const BrandingHeader({
    super.key,
    this.showSubtitle = true,
    this.brandingConfig,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.l),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: AppShadows.card(context),
      ),
      child: Column(
        children: [
          // Logo section - Phase 1: Placeholder icon
          _buildLogoPlaceholder(context),
          const SizedBox(height: AppSizes.m),

          // Title section - Phase 3: Dynamic from BrandingConfig
          Text(
            brandingConfig?.effectiveTitle ?? 'NutriWell Clinic',
            style: AppTextStyles.headerTitle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          // Subtitle section - Phase 3: Dynamic from BrandingConfig
          if (showSubtitle) ...[
            const SizedBox(height: AppSizes.xs),
            Text(
              brandingConfig?.effectiveSubtitle ?? 'with Dr. Sarah Johnson',
              style: AppTextStyles.headerSubtitle.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLogoPlaceholder(BuildContext context) {
    // Phase 1: Placeholder icon
    // TODO: Phase 2 - Load actual logo from assets/branding_config.json
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: Icon(
        Icons.local_dining,
        size: 32,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}