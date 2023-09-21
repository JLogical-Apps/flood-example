import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:template/presentation/pages/home_page.dart';

class PagesAppPondComponent with IsAppPondComponent {
  @override
  Map<Route, AppPage> get pages => {
        HomeRoute(): HomePage(),
        // TODO As you create AppPages, add them here.
      };
}
