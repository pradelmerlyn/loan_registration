import 'package:flutter/material.dart';
import 'package:sprint3_activity/presentation/loan_registration/form_controllers/borrower_info_form_controllers.dart';
import 'package:sprint3_activity/presentation/loan_registration/views/borrower_views/borrower_contact_info_view.dart';
import 'package:sprint3_activity/presentation/loan_registration/views/borrower_views/borrower_current_address_info_view.dart';
import 'package:sprint3_activity/presentation/loan_registration/views/borrower_views/borrower_mailing_address_info_view.dart';
import 'package:sprint3_activity/presentation/loan_registration/views/borrower_views/borrower_military_service_info_view.dart';
import 'package:sprint3_activity/presentation/loan_registration/views/borrower_views/borrower_monthly_expense_info_view.dart';
import 'package:sprint3_activity/presentation/loan_registration/views/borrower_views/borrower_personal_info_view.dart';
import 'package:sprint3_activity/presentation/loan_registration/views/borrower_views/borrower_previous_address_info_view.dart';

class BorrowerView extends StatelessWidget {
  final BorrowerInfoFormControllers controllers;

  const BorrowerView({super.key, required this.controllers});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: controllers.borrowerInfoKey,
        child: Column(
          children: [
            PersonalInfoSection(borrControllers: controllers),
            MilitaryServiceInfoSection(borrControllers: controllers),
            ContactInfoSection(borrControllers: controllers),
            CurrentAddressSection(borrControllers: controllers),
            PreviousAddressSection(borrControllers: controllers),
            MailingAddressSection(borrControllers: controllers),
            MonthlyHousingExpensesSection(borrControllers: controllers),
          ],
        ),
      ),
    );
  }
}




