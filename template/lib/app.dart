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
    appPondContextGetter: () =>
        buildLateAsync<AppPondContext>((appPondContextGetter) async => getAppPondContext(await getCorePondContext(
              environmentConfig: EnvironmentConfig.static.flutterAssets(),
              repositoryImplementations: [
                FlutterFileRepositoryImplementation(),
              ],
            ))),
    splashPage: StyledPage(
      body: Center(
        child: StyledLoadingIndicator(),
      ),
    ),
    notFoundPage: StyledPage(
      body: Center(
        child: StyledText.h1('Not Found!'),
      ),
    ),
    initialPageGetter: () => HomePage(),
    onError: (appPondContext, error, stackTrace) {
      if (appPondContext == null) {
        print(error);
        print(stackTrace);
      } else {
        appPondContext.find<LogCoreComponent>().logError(error, stackTrace);
      }
    },
  );
}

Future<AppPondContext> getAppPondContext(CorePondContext corePondContext) async {
  final appPondContext = AppPondContext(corePondContext: corePondContext);
  await appPondContext.register(NavigationAppComponent());
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
