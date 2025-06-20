import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'core/common/logger/app_logger.dart';
import 'injector.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() {
  getIt.init();

  // Register the logger service as a singleton
  if (!getIt.isRegistered<AppLogger>()) {
    getIt.registerSingleton<AppLogger>(AppLogger.instance);
  }
}
