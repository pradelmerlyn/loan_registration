import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'borrower_view_event.dart';
part 'borrower_view_state.dart';

class BorrowerViewBloc extends Bloc<BorrowerViewEvent, BorrowerViewState> {
  BorrowerViewBloc() : super(const BorrowerViewState()) {
    on<ToggleSSN>(onShowSSN);
    on<SsnEdited>(onUpdateSSN);
  }

  void onShowSSN(
      ToggleSSN event, Emitter<BorrowerViewState> emit) async {
      emit(state.copyWith(obscureSSN: !state.obscureSSN));
      
  }
  void onUpdateSSN(SsnEdited event, Emitter<BorrowerViewState> emit) async {
    emit(state.copyWith(ssn: _digitsOnly(event.input)));
  }

   // ------- helpers ----- //
  String _digitsOnly(String v) => v.replaceAll(RegExp(r'[^0-9]'), '');
  String _formatSsn(String raw) {
    final d = _digitsOnly(raw);
    if (d.isEmpty) return '';
    final b1 = d.length >= 3 ? d.substring(0, 3) : d;
    final b2 = d.length >= 5
        ? d.substring(3, 5)
        : (d.length > 3 ? d.substring(3) : '');
    final b3 = d.length > 5 ? d.substring(5) : '';
    return [b1, if (d.length > 3) b2, if (d.length > 5) b3].join('-');
  }

  String _maskSsn(String raw) {
    final d = _digitsOnly(raw);
    if (d.isEmpty) return '';
    final last4 = d.length <= 4 ? d : d.substring(d.length - 4);
    return '***-**-$last4';
  }

  String _formatDate(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    final yy = d.year.toString();
    return '$mm/$dd/$yy';
  }

  // Form field validation
  String? requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}
