import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:template/presentation/pages/home_page.dart';

class PagesAppPondComponent with IsAppPondComponent {
  @override
  List<AppPage> get pages => [
        HomePage(),
        // TODO As you create AppPages, add them here.
      ];
}
