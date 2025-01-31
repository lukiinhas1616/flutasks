import 'package:flutasks/core/utils/app_routes/task_module_routes.dart';
import 'package:flutasks/modules/coordinator/presentation/controllers/events/start_storage_event.dart';
import 'package:flutasks/modules/coordinator/presentation/controllers/states/successfully_got_coordinator_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../controllers/blocs/coordinator_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final bloc = Modular.get<CoordinatorBloc>();

  @override
  void initState() {
    super.initState();
    bloc.add(const StartStorageEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: bloc,
      listener: (context, state) {
        if (state is SuccessfullyGotCoordinatorState) {
          Modular.to.navigate(TaskModuleRoutes.base);
        }
      },
      builder: (context, state) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
