import 'package:flood/flood.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todo/presentation/utils/user_theme_extensions.dart';
import 'package:todo_core/features/user/user.dart';
import 'package:todo_core/features/user/user_entity.dart';
import 'package:todo_core/features/user/user_theme.dart';

class ThemeSwitcher extends HookWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedInUserId = useLoggedInUserId();
    final loggedInUserModel = useEntity<UserEntity>(loggedInUserId);

    useListen(
      useMemoized(() => loggedInUserModel.stateX),
      (FutureValue<UserEntity> maybeUser) {
        final userEntity = maybeUser.getOrNull();
        if (userEntity == null) {
          return;
        }

        final userStyle = userEntity.value.themeProperty.value.style;
        final style = context.styleAppComponent.style;

        if (userStyle != style) {
          context.styleAppComponent.style = userStyle;
        }
      },
    );

    return ModelBuilder(
      model: loggedInUserModel,
      builder: (UserEntity userEntity) {
        return userEntity.value.themeProperty.value == UserTheme.dark
            ? StyledButton(
                iconData: Icons.dark_mode,
                onPressed: () async {
                  await context.dropCoreComponent.updateEntity(
                    userEntity,
                    (User user) => user..themeProperty.set(UserTheme.light),
                  );
                },
              )
            : StyledButton(
                iconData: Icons.light_mode,
                onPressed: () async {
                  await context.dropCoreComponent.updateEntity(
                    userEntity,
                    (User user) => user..themeProperty.set(UserTheme.dark),
                  );
                },
              );
      },
    );
  }
}
