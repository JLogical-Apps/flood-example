import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class HomeRoute with IsRoute<HomeRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.home;

  @override
  HomeRoute copy() {
    return HomeRoute();
  }
}

class HomePage with IsAppPage<HomeRoute> {
  @override
  Widget onBuild(BuildContext context, HomeRoute route) {
    return StyledPage(
      titleText: 'Hello',
      body: StyledList.column.withScrollbar(
        children: [
          StyledText.body('Hello World!'),
        ],
      ),
    );
  }
}
