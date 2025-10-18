import 'package:flutter/material.dart';
import 'package:van_view_app/themes/styles.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.colors,
    required this.paddings,
    required this.textStyles,
    required this.iconSizes,
  });
  final AppColors colors;
  final AppPaddings paddings;
  final AppTextStyles textStyles;
  final AppIconSizes iconSizes;

  @override
  AppThemeExtension copyWith({
    AppPaddings? paddings,
    AppTextStyles? textStyles,
    AppColors? colors,
    AppIconSizes? iconSizes,
  }) {
    return AppThemeExtension(
      colors: colors ?? this.colors,
      paddings: paddings ?? this.paddings,
      textStyles: textStyles ?? this.textStyles,
      iconSizes: iconSizes ?? this.iconSizes,
    );
  }

  @override
  AppThemeExtension lerp(
    covariant ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      colors: other.colors,
      paddings: other.paddings,
      textStyles: other.textStyles,
      iconSizes: other.iconSizes,
    );
  }
}
