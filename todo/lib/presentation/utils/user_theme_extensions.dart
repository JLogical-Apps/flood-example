import 'package:flood/flood.dart';
import 'package:todo/presentation/style.dart';
import 'package:todo_core/features/user/user_theme.dart';

extension UserThemeExtensions on UserTheme {
  Style get style => switch (this) {
        UserTheme.light => lightStyle,
        UserTheme.dark => darkStyle,
      };
}
