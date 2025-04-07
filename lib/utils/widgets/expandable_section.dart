import 'package:flutter/material.dart';
import 'package:jejom/utils/theme/app_theme.dart';

/// An expandable/collapsible section for organizing content
/// Provides a clean way to hide detailed information until needed
class ExpandableSection extends StatefulWidget {
  /// Title text for the section header
  final String title;
  
  /// Optional icon to display before the title
  final IconData? icon;
  
  /// Content to display when expanded
  final Widget content;
  
  /// Initial expansion state
  final bool initiallyExpanded;
  
  /// Padding around the content
  final EdgeInsetsGeometry contentPadding;
  
  /// Additional padding around the entire widget
  final EdgeInsetsGeometry padding;
  
  /// Callback fired when expansion state changes
  final ValueChanged<bool>? onExpansionChanged;
  
  /// Background color for the header
  final Color? headerBackgroundColor;
  
  /// Background color for the content
  final Color? contentBackgroundColor;
  
  /// Whether to add a divider between header and content
  final bool showDivider;
  
  /// Custom animation duration
  final Duration animationDuration;

  const ExpandableSection({
    super.key,
    required this.title,
    this.icon,
    required this.content,
    this.initiallyExpanded = false,
    this.contentPadding = const EdgeInsets.all(AppTheme.paddingMedium),
    this.padding = const EdgeInsets.symmetric(vertical: AppTheme.paddingSmall),
    this.onExpansionChanged,
    this.headerBackgroundColor,
    this.contentBackgroundColor,
    this.showDivider = false,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _heightFactor;
  late final Animation<double> _iconTurns;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
    _iconTurns = _controller.drive(
      Tween<double>(begin: 0.0, end: 0.5).chain(
        CurveTween(curve: Curves.easeInOut),
      ),
    );

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          
          // Expandable content
          AnimatedBuilder(
            animation: _controller.view,
            builder: _buildExpandableContent,
            child: Container(
              color: widget.contentBackgroundColor,
              padding: widget.contentPadding,
              child: widget.content,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Material(
      color: widget.headerBackgroundColor ?? Colors.transparent,
      child: InkWell(
        onTap: _handleTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.paddingMedium,
            vertical: AppTheme.paddingSmall,
          ),
          child: Row(
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 20,
                  color: AppTheme.travelPrimary,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  widget.title,
                  style: AppTheme.labelLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              RotationTransition(
                turns: _iconTurns,
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.textMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableContent(BuildContext context, Widget? child) {
    if (widget.showDivider && _heightFactor.value > 0) {
      return Column(
        children: [
          if (_heightFactor.value > 0)
            Divider(
              height: 1,
              thickness: 1,
              color: AppTheme.textLight.withOpacity(0.2),
            ),
          ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      );
    }

    return ClipRect(
      child: Align(
        alignment: Alignment.topCenter,
        heightFactor: _heightFactor.value,
        child: child,
      ),
    );
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      widget.onExpansionChanged?.call(_isExpanded);
    });
  }
}

/// A simpler variant designed specifically for FAQ sections
class FaqExpandableItem extends StatelessWidget {
  /// The question text
  final String question;
  
  /// The answer text
  final String answer;
  
  /// Whether the item is initially expanded
  final bool initiallyExpanded;
  
  /// Callback when expansion state changes
  final ValueChanged<bool>? onExpansionChanged;

  const FaqExpandableItem({
    super.key,
    required this.question,
    required this.answer,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableSection(
      title: question,
      initiallyExpanded: initiallyExpanded,
      onExpansionChanged: onExpansionChanged,
      showDivider: true,
      content: Text(
        answer,
        style: AppTheme.bodyMedium,
      ),
    );
  }
} 