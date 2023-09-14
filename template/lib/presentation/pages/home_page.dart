import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class HomePage extends AppPage {
  @override
  PathDefinition get pathDefinition => PathDefinition.home;

  @override
  Widget build(BuildContext context) {
    return StyledPage(
      titleText: 'Hello',
      body: StyledList.column.withScrollbar(
        children: [
          StyledText.body('Hello World!'),
        ],
      ),
    );
  }

  @override
  AppPage copy() {
    return HomePage();
  }
}
