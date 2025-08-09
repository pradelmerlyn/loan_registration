part of 'loan_registration_bloc.dart';

const List<IconData> appBarIcons = [
  Icons.person,
  Icons.home_outlined,
  Icons.attach_money,
  Icons.checklist_rtl,
  Icons.group,
];

class LoanRegistrationState extends Equatable {
  final int currentStep;
  final String stepLabel;
  final int completionPercentage;
  final String buttonLabel;

  const LoanRegistrationState({
    this.currentStep = 1,
    this.stepLabel = 'Borrower',
    this.completionPercentage = 20,
    this.buttonLabel = 'Next',
  });

  LoanRegistrationState copyWith({
    int? currentStep,
    String? stepLabel,
    int? completionPercentage,
    String? buttonLabel,
  }) {
    return LoanRegistrationState(
      currentStep: currentStep ?? this.currentStep,
      stepLabel: stepLabel ?? this.stepLabel,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      buttonLabel: buttonLabel ?? this.buttonLabel,
    );
  }

  @override
  List<Object> get props => [currentStep, stepLabel, completionPercentage, buttonLabel];
}
