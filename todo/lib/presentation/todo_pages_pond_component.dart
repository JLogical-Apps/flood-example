import 'package:flood/flood.dart';
import 'package:todo/presentation/pages/auth/login_page.dart';
import 'package:todo/presentation/pages/auth/signup_page.dart';
import 'package:todo/presentation/pages/home_page.dart';

class TodoPagesAppPondComponent with IsAppPondComponent {
  @override
  Map<Route, AppPage> get pages => {
        LoginRoute(): LoginPage(),
        SignupRoute(): SignupPage(),
        HomeRoute(): HomePage(),
      };
}
