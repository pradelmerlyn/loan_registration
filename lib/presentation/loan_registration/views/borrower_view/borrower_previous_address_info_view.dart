import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:loan_registration/presentation/widgets/section_header.dart';
import 'package:loan_registration/presentation/widgets/form_textfield.dart';
import 'package:loan_registration/presentation/widgets/dropdown_field.dart';
import 'package:loan_registration/presentation/loan_registration/form_controllers/borrower_info_form_controllers.dart';

class PreviousAddressSection extends StatelessWidget {
  final BorrowerInfoFormControllers borrControllers;
  const PreviousAddressSection({super.key, required this.borrControllers});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(label: 'Previous Address'),
          _PrevAddressLine1Field(ctrl: borrControllers.prevAddressLine1Ctrl),
          _PrevUnitAndCityRow(
            unitCtrl: borrControllers.prevUnitNoCtrl,
            cityCtrl: borrControllers.prevCityCtrl,
          ),
          _PrevStateAndZipRow(
            stateCtrl: borrControllers.prevStateCtrl,
            zipCtrl: borrControllers.prevZipCodeCtrl,
          ),
          _PrevStartAndEndDatesRow(
            startCtrl:
                borrControllers.prevStartDateCtrl, 
            endCtrl: borrControllers.prevEndDateCtrl,
          ),
        ],
      ),
    );
  }
}

//** ------- FIELDS ------** /

class _PrevAddressLine1Field extends StatelessWidget {
  final TextEditingController ctrl;
  const _PrevAddressLine1Field({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 16),
      FormTextField(
        label: 'Address Line 1',
        controller: ctrl,
        validator: (v) => (v == null || v.trim().isEmpty)
            ? 'Address Line 1 is required'
            : null,
      ),
    ]);
  }
}

class _PrevUnitAndCityRow extends StatelessWidget {
  final TextEditingController unitCtrl;
  final TextEditingController cityCtrl;
  const _PrevUnitAndCityRow({required this.unitCtrl, required this.cityCtrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            child: FormTextField(
              label: 'Apt/Unit/Suite',
              controller: unitCtrl,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FormTextField(
              label: 'City',
              controller: cityCtrl,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'City is required' : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrevStateAndZipRow extends StatelessWidget {
  final TextEditingController stateCtrl;
  final TextEditingController zipCtrl;
  const _PrevStateAndZipRow({required this.stateCtrl, required this.zipCtrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            child: DropDownField<String>(
              label: "State",
              value: stateCtrl.text.isEmpty ? null : stateCtrl.text,
              items: const [
                DropdownMenuItem(
                    value: "California", child: Text("California")),
                DropdownMenuItem(value: "Arizona", child: Text("Arizona")),
                DropdownMenuItem(value: "Nevada", child: Text("Nevada")),
                DropdownMenuItem(value: "Texas", child: Text("Texas")),
              ],
              onChanged: (v) => stateCtrl.text = v ?? '',
              validator: (v) =>
                  v == null || v.isEmpty ? "State is required" : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FormTextField(
              label: 'Zip Code',
              controller: zipCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (v) {
                final t = (v ?? '').trim();
                if (t.isEmpty) return 'Zip Code is required';
                if (t.length < 5) return 'Enter a valid zip code';
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PrevStartAndEndDatesRow extends StatelessWidget {
  final TextEditingController startCtrl;
  final TextEditingController endCtrl;
  const _PrevStartAndEndDatesRow({
    required this.startCtrl,
    required this.endCtrl,
  });

  Future<void> _pickDate(
      BuildContext context, TextEditingController ctrl) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      ctrl.text =
          '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            child: FormTextField(
              label: 'Start Date',
              controller: startCtrl,
              readOnly: true,
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today_rounded),
                onPressed: () => _pickDate(context, startCtrl),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Start Date is required' : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FormTextField(
              label: 'End Date',
              controller: endCtrl,
              readOnly: true,
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today_rounded),
                onPressed: () => _pickDate(context, endCtrl),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'End Date is required' : null,
            ),
          ),
        ],
      ),
    );
  }
}
