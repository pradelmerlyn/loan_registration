import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:loan_registration/presentation/loan_registration/bloc/borrower_view/borrower_view_bloc.dart';
import 'package:loan_registration/presentation/loan_registration/bloc/loan_registration/loan_registration_bloc.dart';
import 'package:loan_registration/presentation/loan_registration/form_controllers/borrower_info_form_controllers.dart';
import 'package:loan_registration/presentation/loan_registration/views/borrower_views/borrower_view.dart';
import 'package:loan_registration/presentation/widgets/button_outlined.dart';

class LoanRegistrationScreen extends StatefulWidget {
  const LoanRegistrationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoanRegistrationScreen();
}

class _LoanRegistrationScreen extends State<LoanRegistrationScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final BorrowerInfoFormControllers controllers;
  final GlobalKey<FormState> borrowerFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> propertyFormKey = GlobalKey<FormState>();

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
      create: (_) => LoanRegistrationBloc(),
      child: BlocListener<LoanRegistrationBloc, LoanRegistrationState>(
        listener: (context, state) {
          final targetIndex = state.currentStep - 1;
          debugPrint('${state.currentStep}');
          if (_tabController.index != targetIndex) {
            _tabController.animateTo(targetIndex);
          }
          if (kDebugMode) debugPrint(targetIndex.toString());
        },
        child: BlocBuilder<LoanRegistrationBloc, LoanRegistrationState>(
          builder: (context, state) {
            final currStep = state.currentStep;
            final isFirstStep = currStep == 1;
            final isLastStep = currStep == 5; // adjust if steps change
            final nextLabel = isLastStep ? 'SUBMIT' : 'NEXT';

            return Scaffold(
              appBar: AppBar(
                title:
                    Text(state.stepLabel.isEmpty ? 'App Bar' : state.stepLabel),
                backgroundColor: _themeData!.colorScheme.primaryContainer,
              ),
              body: Column(
                children: [
                  const SizedBox(height: 8),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        BlocProvider(
                          create: (_) => BorrowerViewBloc(),
                          child: BorrowerView(controllers: controllers),
                        ),
                        const Center(child: Text('Property Form')),
                        const Center(child: Text('Financial Form')),
                        const Center(child: Text('Declarations Form')),
                        const Center(child: Text('Demographics Form')),
                      ],
                    ),
                  ),
                ],
              ),

              // Sticky bottom action bar
              bottomNavigationBar: _BottomNavigation(
                isFirstStep: isFirstStep, 
                nextLabel: nextLabel, 
                currStep: currStep,
                borrowerFormKey: borrowerFormKey,
                propertyFormKey: propertyFormKey,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BottomNavigation extends StatefulWidget {
  final GlobalKey<FormState> borrowerFormKey;
  final GlobalKey<FormState> propertyFormKey;
  final bool isFirstStep;
  final String nextLabel;
  final int currStep;

 const _BottomNavigation({
    required this.isFirstStep, 
    required this.nextLabel, 
    required this.currStep, 
    required this.borrowerFormKey, 
    required this.propertyFormKey
  });

  @override
  State<_BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<_BottomNavigation> {
  ThemeData? _theme;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
  }

  @override
  Widget build(BuildContext context) {

  
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Row(
          children: [
            // LEFT: CANCEL (step 1) or BACK (step 2+)
            Expanded(
              child: ButtonOutlined(
                label: widget.isFirstStep ? 'CANCEL' : 'BACK',
                onPressed: () {
                  SystemChannels.textInput
                      .invokeMethod('TextInput.hide');
                  if (widget.isFirstStep) {
                    Navigator.of(context).maybePop();
                  } else {
                    context
                        .read<LoanRegistrationBloc>()
                        .add(PrevStepsEvent());
                  }
                },
                backgroundColor: Colors.white,
                foregroundColor: _theme!.colorScheme.primary,
                borderColor:  _theme!.colorScheme.primary
              ),
            ),
            const SizedBox(width: 16),

            // RIGHT BUTTON: NEXT / SUBMIT
            Expanded(
              child: ButtonOutlined(
                label: widget.nextLabel,
                onPressed: () {
                  SystemChannels.textInput
                      .invokeMethod('TextInput.hide');

                  if (widget.currStep == 1) {
                    if (widget.borrowerFormKey.currentState?.validate() ??
                        true) {
                      context
                          .read<LoanRegistrationBloc>()
                          .add(NextStepsEvent());
                    }
                  } else if (widget.currStep == 2) {
                    if (widget.propertyFormKey.currentState?.validate() ??
                        true) {
                      context
                          .read<LoanRegistrationBloc>()
                          .add(NextStepsEvent());
                    }
                  } else {
                    context
                        .read<LoanRegistrationBloc>()
                        .add(NextStepsEvent());
                  }
                },
                backgroundColor: _theme!.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
