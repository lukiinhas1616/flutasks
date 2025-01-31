import 'package:flutasks/core/shared/domain/services/local_storage_service.dart';
import 'package:flutasks/core/utils/app_routes/coordinator_module_routes.dart';
import 'package:flutasks/modules/coordinator/domain/repositories/coordinator_repository.dart';
import 'package:flutasks/modules/coordinator/domain/usecases/start_local_storage_usecase.dart';
import 'package:flutasks/modules/coordinator/infra/repositories/coordinator_repository_imp.dart';
import 'package:flutasks/modules/coordinator/presentation/controllers/blocs/coordinator_bloc.dart';
import 'package:flutasks/modules/coordinator/presentation/ui/pages/splash_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../app_module.dart';

class CoordinatorModule extends Module {
  @override
  List<Module> get imports => [AppModule()];

  @override
  void binds(Injector i) {
    i.add<CoordinatorRepository>(
      () => CoordinatorRepositoryImp(i<LocalStorageService>()),
    );

    i.add<StartLocalStorageUseCase>(
      () => StartLocalStorageUseCaseImp(i<CoordinatorRepository>()),
    );

    i.add<CoordinatorBloc>(
      () => CoordinatorBloc(
        i<StartLocalStorageUseCase>(),
      ),
    );
  }

  @override
  void routes(RouteManager r) {
    r.child(
      CoordinatorModuleRoutes.base,
      child: (_) => const SplashPage(),
    );
  }
}
