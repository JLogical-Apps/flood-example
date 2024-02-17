import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:template/presentation/pages/home_page.dart';
import 'package:template/presentation/pages_pond_component.dart';
import 'package:template/presentation/style.dart';
import 'package:template_core/pond.dart';

// Whether to set up test data in the test suite.
const shouldAddTestData = true;

Future<void> main(List<String> args) async {
  await PondApp.run(
    appPondContextGetter: buildAppPondContext,
    loadingPage: StyledLoadingPage(),
    notFoundPage: StyledPage(
      body: Center(
        child: StyledText.h1('Not Found!'),
      ),
    ),
    initialRouteGetter: () => HomeRoute(),
  );
}

Future<AppPondContext> buildAppPondContext() async {
  final corePondContext = await getCorePondContext(
    environmentConfig: EnvironmentConfig.static.flutterAssets(),
    loggerService: (corePondContext) => corePondContext.environment.isOnline
        ? LoggerService.static.console.withFileLogHistory(corePondContext.fileSystem.tempDirectory / 'logs')
        : LoggerService.static.console,
  );

  final appPondContext = AppPondContext(corePondContext: corePondContext);
  await appPondContext.register(DebugAppComponent());
  await appPondContext.register(LogAppComponent());
  await appPondContext.register(DeviceFilesAppComponent());
  await appPondContext.register(FocusGrabberAppComponent());
  await appPondContext.register(AuthAppComponent());
  await appPondContext.register(DropAppComponent());
  await appPondContext.register(ResetAppComponent());
  await appPondContext.register(PortStyleAppComponent(overrides: []));
  await appPondContext.register(StyleAppComponent(style: style));
  await appPondContext.register(UrlBarAppComponent());
  await appPondContext.register(EnvironmentBannerAppComponent());
  await appPondContext.register(ShareAppComponent());
  await appPondContext.register(TestingSetupAppComponent(onSetup: () async {
    if (shouldAddTestData) {
      await _setupTesting(corePondContext);
    }
  }));
  await appPondContext.register(PagesAppPondComponent());

  return appPondContext;
}

Future<void> _setupTesting(CorePondContext corePondContext) async {
  // TODO Set up test data here.
}
