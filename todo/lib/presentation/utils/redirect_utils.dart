import 'package:flood/flood.dart';
import 'package:todo/presentation/pages/auth/login_page.dart';
import 'package:todo/presentation/pages/home_page.dart';

extension RedirectAppPageExtensions<R extends Route> on AppPage<R> {
  AppPage<R> onlyIfLoggedIn() {
    return withRedirect((context, route) async {
      final loggedInUserId = context.find<AuthCoreComponent>().loggedInUserId;
      if (loggedInUserId == null) {
        return LoginRoute().routeData;
      }

      return null;
    });
  }

  AppPage<R> onlyIfNotLoggedIn() {
    return withRedirect((context, route) async {
      final loggedInUserId = context.find<AuthCoreComponent>().loggedInUserId;
      if (loggedInUserId != null) {
        return HomeRoute().routeData;
      }

      return null;
    });
  }
}
