import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprint3_activity/presentation/loan_registration/bloc/borrower_view/borrower_view_bloc.dart';
import 'package:sprint3_activity/presentation/loan_registration/bloc/loan_registration/loan_registration_bloc.dart';
import 'package:sprint3_activity/presentation/loan_registration/form_controllers/borrower_info_form_controllers.dart';
import 'package:sprint3_activity/presentation/loan_registration/views/borrower_views/borrower_view.dart';

class LoanRegistrationScreen extends StatefulWidget {
  const LoanRegistrationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoanRegistrationScreen();
}

class _LoanRegistrationScreen extends State<LoanRegistrationScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final BorrowerInfoFormControllers controllers;

  ThemeData? _themeData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    controllers = BorrowerInfoFormControllers.init();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _themeData = Theme.of(context);
  }

  @override
  void dispose() {
    _tabController.dispose();
    controllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoanRegistrationBloc(),
      child: BlocListener<LoanRegistrationBloc, LoanRegistrationState>(
        listener: (context, state) {
          final targetIndex = state.currentStep - 1;
          if (_tabController.index != targetIndex) {
            _tabController.animateTo(targetIndex);
          }
          if (kDebugMode) {
            debugPrint(targetIndex as String?);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('App Bar'),
            backgroundColor: _themeData!.colorScheme.primaryContainer,
          ),
          body: Column(
            children: [
              Text('Personal Info'),

              // Content Area
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    BlocProvider(
                      create: (context) => BorrowerViewBloc(),
                      child: BorrowerView(controllers: controllers),
                    ),
                    Center(child: Text('Property Form')),
                    Center(child: Text('Financial Form')),
                    Center(child: Text('Declarations Form')),
                    Center(child: Text('Demographics Form')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
