import 'package:flutter/material.dart';
import 'package:jejom/utils/theme/app_theme.dart';

/// A consistent section header to be used throughout the app
/// Provides standardized styling for content organization
class SectionHeader extends StatelessWidget {
  /// Title text for the section
  final String title;
  
  /// Optional subtitle text
  final String? subtitle;
  
  /// Optional icon to display before the title
  final IconData? icon;
  
  /// Optional action button text
  final String? actionText;
  
  /// Optional action button icon
  final IconData? actionIcon;
  
  /// Callback when the action button is tapped
  final VoidCallback? onActionTap;
  
  /// Whether to create a divider below the header
  final bool showDivider;
  
  /// Whether to add padding around the header
  final bool addPadding;
  
  /// Custom style for the title text
  final TextStyle? titleStyle;
  
  /// Background color for the header
  final Color? backgroundColor;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.actionText,
    this.actionIcon,
    this.onActionTap,
    this.showDivider = false,
    this.addPadding = true,
    this.titleStyle,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final headerContent = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title section
        Expanded(
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                  color: AppTheme.travelPrimary,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: titleStyle ??
                          AppTheme.labelLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textMedium,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Action button
        if (actionText != null || actionIcon != null) ...[
          GestureDetector(
            onTap: onActionTap,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  if (actionText != null) ...[
                    Text(
                      actionText!,
                      style: AppTheme.labelMedium.copyWith(
                        color: AppTheme.travelPrimary,
                      ),
                    ),
                    if (actionIcon != null) const SizedBox(width: 4),
                  ],
                  if (actionIcon != null) 
                    Icon(
                      actionIcon,
                      size: 18,
                      color: AppTheme.travelPrimary,
                    ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
    
    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: backgroundColor,
          padding: addPadding
              ? const EdgeInsets.only(
                  top: AppTheme.paddingMedium,
                  bottom: AppTheme.paddingSmall,
                )
              : EdgeInsets.zero,
          child: headerContent,
        ),
        if (showDivider)
          Divider(
            color: AppTheme.textLight.withOpacity(0.3),
            height: 1,
          ),
      ],
    );
    
    if (addPadding) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.paddingMedium,
        ),
        child: header,
      );
    }
    
    return header;
  }
}

/// A smaller, more compact section header variant
class CompactSectionHeader extends StatelessWidget {
  /// Title text for the section
  final String title;
  
  /// Optional action button text
  final String? actionText;
  
  /// Callback when the action button is tapped
  final VoidCallback? onActionTap;

  const CompactSectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingMedium,
        vertical: AppTheme.paddingSmall,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTheme.labelMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textMedium,
            ),
          ),
          if (actionText != null && onActionTap != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionText!,
                style: AppTheme.labelSmall.copyWith(
                  color: AppTheme.travelPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
} 