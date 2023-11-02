import 'dart:async';

import 'package:jlogical_utils_core/jlogical_utils_core.dart';

Future<CorePondContext> getCorePondContext({
  EnvironmentConfig? environmentConfig,
  FutureOr<List<CorePondComponent>> Function(CorePondContext context)? additionalCoreComponents,
  List<RepositoryImplementation> Function(CorePondContext context)? repositoryImplementations,
  List<AuthServiceImplementation> Function(CorePondContext context)? authServiceImplementations,
  MessagingService? Function(CorePondContext context)? messagingService,
  LoggerService? Function(CorePondContext context)? loggerService,
  TaskRunner? Function(CorePondContext context)? taskRunner,
}) async {
  environmentConfig ??= EnvironmentConfig.static.environmentVariables();
  final corePondContext = CorePondContext();

  await corePondContext.register(TypeCoreComponent());
  await corePondContext.register(EnvironmentConfigCoreComponent(environmentConfig: environmentConfig));

  for (final coreComponent in await additionalCoreComponents?.call(corePondContext) ?? []) {
    await corePondContext.register(coreComponent);
  }

  await corePondContext.register(LogCoreComponent(
    loggerService: loggerService?.call(corePondContext) ?? LoggerService.static.console,
  ));

  await corePondContext.register(AuthCoreComponent(
    authService: AuthService.static.adapting(),
    authServiceImplementations: authServiceImplementations?.call(corePondContext) ?? [],
  ));
  await corePondContext.register(DropCoreComponent(
    repositoryImplementations: repositoryImplementations?.call(corePondContext) ?? [],
    loggedInAccountX:
        corePondContext.locate<AuthCoreComponent>().accountX.mapWithValue((maybeUserIdX) => maybeUserIdX.getOrNull()),
  ));
  await corePondContext.register(MessagingCoreComponent(
    messagingService: messagingService?.call(corePondContext) ?? MessagingService.static.blank,
  ));
  await corePondContext.register(ActionCoreComponent(
    actionWrapper: <P, R>(Action<P, R> action) => action.log(context: corePondContext),
  ));
  await corePondContext.register(PortDropCoreComponent());

  // TODO Register repositories here.

  return corePondContext;
}

Future<CorePondContext> getTestingCorePondContext() async {
  final corePondContext = await getCorePondContext(
    environmentConfig: EnvironmentConfig.static.testing(),
  );

  await corePondContext.locate<AuthCoreComponent>().signup('asdf@asdf.com', 'mypassword');

  return corePondContext;
}
