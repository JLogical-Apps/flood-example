import 'package:flood_core/flood_core.dart';
import 'package:todo_core/features/user/user_theme.dart';

class User extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).withDisplayName('Name').isNotBlank();

  static const emailField = 'email';
  late final emailProperty = field<String>(name: emailField).withDisplayName('Email').hidden().isEmail().isNotBlank();

  static const deviceTokenField = 'deviceToken';
  late final deviceTokenProperty = field<String>(name: deviceTokenField).hidden();

  static const themeField = 'theme';
  late final themeProperty = field<int>(name: themeField).hidden().asEnumIndex(
        UserTheme.values,
        defaultValue: UserTheme.dark,
      );

  @override
  late final List<ValueObjectBehavior> behaviors = [
    nameProperty,
    emailProperty,
    deviceTokenProperty,
    themeProperty,
    creationTime(),
  ];
}
