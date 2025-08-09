import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'loan_registration_event.dart';
part 'loan_registration_state.dart';

class LoanRegistrationBloc
    extends Bloc<LoanRegistrationEvent, LoanRegistrationState> {
  LoanRegistrationBloc() : super(const LoanRegistrationState()) {
    on<NextStepsEvent>(_onNextStep);
    on<PrevStepsEvent>(_onPreviousStep);
  }

  void _onNextStep(
      NextStepsEvent event, Emitter<LoanRegistrationState> emit) async {
    final nextStep = (state.currentStep + 1);
    final percentage = (state.completionPercentage + 20);
    debugPrint('_onNextStep: $_getButtonLabel(nextStep)');
    emit(state.copyWith(
      currentStep: nextStep,
      completionPercentage: percentage,
      buttonLabel: _getButtonLabel(nextStep),
      stepLabel: _getAppBarLabel(nextStep),
    ));
  }

  void _onPreviousStep(
      PrevStepsEvent event, Emitter<LoanRegistrationState> emit) async {
    final prevStep = (state.currentStep - 1);
    final percentage = (state.completionPercentage - 20);

    emit(state.copyWith(
      currentStep: prevStep,
      completionPercentage: percentage,
      buttonLabel: _getButtonLabel(prevStep),
      stepLabel: _getAppBarLabel(prevStep),
    ));
  }

  String _getButtonLabel(int step) {
    switch (step) {
      case 1:
        return 'Next';
      case 2:
        return 'Submit';
      default:
        return 'Next';
    }
  }

  String _getAppBarLabel(int step) {
    switch (step) {
      case 1:
        return 'Borrower';
      case 2:
        return 'Property';
      case 3:
        return 'Financial';
      case 4:
        return 'Declarations';
      case 5:
        return 'Demographics';
      default:
        return 'Borrower';
    }
  }
}
