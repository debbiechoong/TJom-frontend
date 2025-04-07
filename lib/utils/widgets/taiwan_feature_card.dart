import 'package:flutter/material.dart';
import 'package:jejom/utils/iconography/app_icons.dart';
import 'package:jejom/utils/theme/app_theme.dart';
import 'package:jejom/utils/widgets/glass_container.dart';

/// A specialized card for displaying Taiwan-specific features
/// Used for highlighting local attractions, transit options, and cultural experiences
class TaiwanFeatureCard extends StatelessWidget {
  /// Title of the feature
  final String title;
  
  /// Description or subtitle text
  final String? description;
  
  /// Primary image URL or asset path
  final String imageUrl;
  
  /// Whether this is an asset image (true) or network image (false)
  final bool isAssetImage;
  
  /// Category of the feature (used for icon selection)
  final String category;
  
  /// Action to perform when the card is tapped
  final VoidCallback? onTap;
  
  /// Optional badge text (e.g., "Popular", "New")
  final String? badgeText;
  
  /// Optional distance information (e.g., "2.3 km away")
  final String? distance;
  
  /// Optional price or cost indicator
  final String? price;
  
  /// Whether this item is marked as a favorite
  final bool isFavorite;
  
  /// Callback when favorite status is toggled
  final ValueChanged<bool>? onFavoriteToggle;
  
  const TaiwanFeatureCard({
    super.key,
    required this.title,
    this.description,
    required this.imageUrl,
    this.isAssetImage = false,
    required this.category,
    this.onTap,
    this.badgeText,
    this.distance,
    this.price,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.9; // 90% of screen width
    
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.paddingMedium,
          vertical: AppTheme.paddingSmall,
        ),
        child: GlassContainer(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          blurIntensity: 8.0,
          backgroundColor: Colors.white.withOpacity(0.15),
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Featured image with category badge
              Stack(
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppTheme.borderRadius),
                      topRight: Radius.circular(AppTheme.borderRadius),
                    ),
                    child: isAssetImage
                        ? Image.asset(
                            imageUrl,
                            height: 150,
                            width: cardWidth,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            imageUrl,
                            height: 150,
                            width: cardWidth,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 150,
                                width: cardWidth,
                                color: AppTheme.backgroundSecondary,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: AppTheme.textMedium,
                                  size: 40,
                                ),
                              );
                            },
                          ),
                  ),
                  
                  // Category badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            AppIcons.getCategoryIcon(category),
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            category,
                            style: AppTheme.labelSmall.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Special badge (if any)
                  if (badgeText != null)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.travelPrimary,
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                        ),
                        child: Text(
                          badgeText!,
                          style: AppTheme.labelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  
                  // Favorite button
                  if (onFavoriteToggle != null)
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => onFavoriteToggle?.call(!isFavorite),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              
              // Content section
              Padding(
                padding: const EdgeInsets.all(AppTheme.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: AppTheme.labelLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    if (description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        description!,
                        style: AppTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    
                    const SizedBox(height: 12),
                    
                    // Details row (distance & price)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (distance != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.place_outlined,
                                size: 14,
                                color: AppTheme.textMedium,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                distance!,
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.textMedium,
                                ),
                              ),
                            ],
                          )
                        else
                          const SizedBox(),
                          
                        if (price != null)
                          Text(
                            price!,
                            style: AppTheme.labelMedium.copyWith(
                              color: AppTheme.travelPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        else
                          const SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A specialized version that highlights Taiwan transportation options
class TaiwanTransportCard extends StatelessWidget {
  /// Name of the transportation service
  final String name;
  
  /// Type of transport (mrt, bus, train, etc.)
  final String transportType;
  
  /// Optional line information (e.g. "Red Line", "No. 307")
  final String? lineInfo;
  
  /// Time information (e.g. "Departs in 5 min")
  final String timeInfo;
  
  /// Estimated cost
  final String? cost;
  
  /// Action to perform when tapped
  final VoidCallback? onTap;

  const TaiwanTransportCard({
    super.key,
    required this.name,
    required this.transportType,
    this.lineInfo,
    required this.timeInfo,
    this.cost,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get the appropriate icon based on transport type
    IconData transportIcon;
    Color transportColor;
    
    switch (transportType.toLowerCase()) {
      case 'mrt':
        transportIcon = AppIcons.mrt;
        transportColor = Colors.blue;
        break;
      case 'bus':
        transportIcon = AppIcons.bus;
        transportColor = Colors.green;
        break;
      case 'train':
        transportIcon = AppIcons.highSpeedRail;
        transportColor = Colors.orange;
        break;
      case 'ferry':
        transportIcon = AppIcons.ferry;
        transportColor = Colors.lightBlue;
        break;
      default:
        transportIcon = AppIcons.transit;
        transportColor = Colors.purple;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppTheme.paddingMedium,
          vertical: AppTheme.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          boxShadow: AppTheme.shadowSmall,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          child: Row(
            children: [
              // Transport icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: transportColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  transportIcon,
                  color: transportColor,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTheme.labelLarge.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    if (lineInfo != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        lineInfo!,
                        style: AppTheme.bodySmall.copyWith(
                          color: transportColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      timeInfo,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textMedium,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Cost
              if (cost != null) ...[
                Text(
                  cost!,
                  style: AppTheme.labelMedium.copyWith(
                    color: AppTheme.textDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 