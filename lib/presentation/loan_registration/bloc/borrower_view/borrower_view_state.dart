part of 'borrower_view_bloc.dart';

final class BorrowerViewState extends Equatable {
  final bool obscureSSN;
  final String ssn;
  const BorrowerViewState({
    this.ssn = '',
    this.obscureSSN = false,
  });

  BorrowerViewState copyWith({
    bool? obscureSSN,
    String? ssn,
  }) {
    return BorrowerViewState(
      obscureSSN: obscureSSN ?? this.obscureSSN,
      ssn: ssn ?? this.ssn,
      
    );
  }

  @override
  List<Object> get props => [obscureSSN, ssn];
}
