import 'package:flutter/material.dart';
import 'package:jejom/utils/theme/app_theme.dart';

/// A breadcrumb trail item representing a navigation step
class BreadcrumbItem {
  /// Display name for this navigation step
  final String label;
  
  /// Optional icon to display before the label
  final IconData? icon;
  
  /// Action to perform when this breadcrumb is tapped
  final VoidCallback onTap;
  
  /// Is this the currently active/selected step?
  final bool isActive;

  BreadcrumbItem({
    required this.label,
    this.icon,
    required this.onTap,
    this.isActive = false,
  });
}

/// A breadcrumb navigation system for deep navigation hierarchies
/// Particularly useful for mystery games with multiple levels
class BreadcrumbNavigator extends StatelessWidget {
  /// List of breadcrumb items to display in the navigator
  final List<BreadcrumbItem> items;
  
  /// Whether to scroll horizontally when items overflow
  final bool isScrollable;
  
  /// Custom separator between items (defaults to '>')
  final Widget? separator;

  const BreadcrumbNavigator({
    super.key,
    required this.items,
    this.isScrollable = true,
    this.separator,
  });

  @override
  Widget build(BuildContext context) {
    final defaultSeparator = Icon(
      Icons.chevron_right_rounded,
      size: 18,
      color: AppTheme.textMedium,
    );

    final breadcrumbItems = <Widget>[];
    
    for (int i = 0; i < items.length; i++) {
      // Add the breadcrumb item
      breadcrumbItems.add(
        _buildBreadcrumbItem(items[i]),
      );
      
      // Add separator if not the last item
      if (i < items.length - 1) {
        breadcrumbItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: separator ?? defaultSeparator,
          ),
        );
      }
    }

    if (isScrollable) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          vertical: AppTheme.paddingSmall,
          horizontal: AppTheme.paddingMedium,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: breadcrumbItems,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppTheme.paddingSmall,
          horizontal: AppTheme.paddingMedium,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: breadcrumbItems,
        ),
      );
    }
  }

  Widget _buildBreadcrumbItem(BreadcrumbItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 8.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.icon != null) ...[
              Icon(
                item.icon,
                size: 16,
                color: item.isActive ? AppTheme.travelPrimary : AppTheme.textMedium,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              item.label,
              style: item.isActive
                  ? AppTheme.labelMedium.copyWith(
                      color: AppTheme.travelPrimary,
                      fontWeight: FontWeight.bold,
                    )
                  : AppTheme.labelMedium.copyWith(
                      color: AppTheme.textMedium,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A simpler version of breadcrumb showing just current location
/// More compact for limited header space
class MiniBreadcrumb extends StatelessWidget {
  /// Current section title
  final String currentTitle;
  
  /// Previous section title
  final String? previousTitle;
  
  /// Action when tapping to go back
  final VoidCallback? onBackTap;

  const MiniBreadcrumb({
    super.key,
    required this.currentTitle,
    this.previousTitle,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (previousTitle != null && onBackTap != null) ...[
          GestureDetector(
            onTap: onBackTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  previousTitle!,
                  style: AppTheme.labelSmall.copyWith(
                    color: AppTheme.textMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 14,
                    color: AppTheme.textMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
        Text(
          currentTitle,
          style: AppTheme.labelMedium.copyWith(
            color: AppTheme.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
} 