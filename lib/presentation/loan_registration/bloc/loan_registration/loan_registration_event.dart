part of 'loan_registration_bloc.dart';

abstract class LoanRegistrationEvent extends Equatable {
  const LoanRegistrationEvent();

  @override
  List<Object> get props => [];
}

class NextStepsEvent extends LoanRegistrationEvent {
  @override
  List<Object> get props => [];
}

class PrevStepsEvent extends LoanRegistrationEvent {
  @override
  List<Object> get props => [];

}
