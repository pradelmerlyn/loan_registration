import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sprint3_activity/presentation/widgets/section_header.dart';
import 'package:sprint3_activity/presentation/widgets/form_textfield.dart';
import 'package:sprint3_activity/presentation/loan_registration/form_controllers/borrower_info_form_controllers.dart';
import 'package:sprint3_activity/presentation/loan_registration/bloc/borrower_view/borrower_view_bloc.dart';

class ContactInfoSection extends StatelessWidget {
  final BorrowerInfoFormControllers borrControllers;
  const ContactInfoSection({super.key, required this.borrControllers});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BorrowerViewBloc>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(label: 'Contact Information'),
          _PhoneNumberField(ctrl: borrControllers.phoneCtrl,),
          _EmailAddressField(ctrl: borrControllers.emailCtrl,),
         
        ],
      ),
    );
  }
}

//** ------- FIELDS ------** /

class _PhoneNumberField extends StatelessWidget {
  final TextEditingController ctrl;
  const _PhoneNumberField({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        FormTextField(
          label: 'Phone Number',
          controller: ctrl,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(15),
          ],
          validator: (v) {
            if ((v ?? '').trim().isEmpty) return 'Phone Number is required';
            if (v!.length < 7) return 'Enter a valid phone number';
            return null;
          },
        ),
      ],
    );
  }
}

class _EmailAddressField extends StatelessWidget {
  final TextEditingController ctrl;
  const _EmailAddressField({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        FormTextField(
          label: 'Email Address',
          controller: ctrl,
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            final value = (v ?? '').trim();
            if (value.isEmpty) return 'Email Address is required';
            final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
            if (!ok) return 'Enter a valid email address';
            return null;
          },
        ),
      ],
    );
  }
}
