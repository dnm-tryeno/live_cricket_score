import 'package:auto_route/auto_route.dart';
import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // Loading page - initial route
    AutoRoute(page: LoadingRoute.page, initial: true),
    // Splash page
    AutoRoute(page: SplashScreenRoute.page),
    // Tutorial page
    AutoRoute(page: TutorialRoute.page),
    // Home page
    AutoRoute(page: HomeRoute.page),
    // Image picker page (intermediate page for camera/gallery)
    AutoRoute(page: ImagePickerRoute.page),
    // Processing page
    AutoRoute(page: ProcessingRoute.page),
    // Editor page
    AutoRoute(page: EditorRoute.page),
    // Background changer page
    AutoRoute(page: BackgroundChangerRoute.page),
    // Result page
    AutoRoute(page: ResultRoute.page),
    // Save page
    AutoRoute(page: SaveRoute.page),
    // Settings page
    AutoRoute(page: SettingsRoute.page),
  ];
}
