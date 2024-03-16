import 'dart:io';

import 'package:flood_cli/flood_cli.dart';
import 'package:todo_core/pond.dart';

Future<void> main(List<String> args) async {
  final corePondContext = await getCorePondContext(
      environmentConfig: EnvironmentConfig.static.fileAssets(projectDirectory: Directory.current.parent / 'todo'));
  final automatePondContext = AutomatePondContext(corePondContext: corePondContext);

  await automatePondContext.register(NativeSetupAutomateComponent(
    appIconForegroundFileGetter: (root) => root / 'assets' - 'logo_foreground_transparent.png',
    backgroundColor: 0xffffff,
    padding: 80,
  ));
  await automatePondContext.register(OpsAutomateComponent(environments: {
    EnvironmentType.static.qa: OpsEnvironment.static.firebaseEmulator,
    EnvironmentType.static.staging: OpsEnvironment.static.firebase,
    EnvironmentType.static.production: OpsEnvironment.static.firebase,
    // TODO Define your Ops environments here.
  }));
  await automatePondContext.register(ReleaseAutomateComponent(
    pipelines: {
      ReleaseEnvironmentType.beta: Pipeline.defaultDeploy({
        ReleasePlatform.android: DeployTarget.googlePlay(GooglePlayTrack.internal, isDraft: true),
        ReleasePlatform.ios: DeployTarget.testflight,
        ReleasePlatform.web: DeployTarget.firebase(channel: 'beta'),
      }),
      // TODO Define your release pipelines here.
    },
    appStoreDeployTargetByPlatform: {
      ReleasePlatform.android: DeployTarget.googlePlay(GooglePlayTrack.beta),
      ReleasePlatform.ios: DeployTarget.appStore,
    },
  ));

  await Automate.automate(
    context: automatePondContext,
    args: args,
    appDirectoryGetter: (coreDirectory) => coreDirectory.parent / 'todo',
  );
}
