part of 'borrower_view_bloc.dart';

abstract class BorrowerViewEvent extends Equatable {
  const BorrowerViewEvent();

  @override
  List<Object> get props => [];
}

class SsnEdited extends BorrowerViewEvent {
  final String input;
  const SsnEdited(this.input);
}

class ToggleSSN extends BorrowerViewEvent {}
