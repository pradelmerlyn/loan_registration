import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sprint3_activity/presentation/widgets/section_header.dart';
import 'package:sprint3_activity/presentation/widgets/form_textfield.dart';
import 'package:sprint3_activity/presentation/loan_registration/form_controllers/borrower_info_form_controllers.dart';

class MonthlyHousingExpensesSection extends StatefulWidget {
  final BorrowerInfoFormControllers borrControllers;
  const MonthlyHousingExpensesSection(
      {super.key, required this.borrControllers});

  @override
  State<MonthlyHousingExpensesSection> createState() =>
      _MonthlyHousingExpensesSectionState();
}

class _MonthlyHousingExpensesSectionState
    extends State<MonthlyHousingExpensesSection> {
  @override
  void initState() {
    super.initState();
    _attachListeners();
    _recomputeTotal();
  }

  void _attachListeners() {
    final c = widget.borrControllers;
    for (var ctrl in [
      c.mortgageCtrl,
      c.subordinateCtrl,
      c.propertyTaxCtrl,
      c.hoaDuesCtrl,
      c.homeInsuranceCtrl,
      c.mortgageInsuranceCtrl,
      c.otherHousingCtrl,
    ]) {
      ctrl.addListener(_recomputeTotal);
    }
  }

  double _toAmount(String s) {
    final t = s.replaceAll(RegExp(r'[^0-9.]'), '');
    if (t.isEmpty) return 0;
    return double.tryParse(t) ?? 0;
  }

  String _fmt(num v) {
    final str = v.toStringAsFixed(0);
    final withCommas = str.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '\$$withCommas';
  }

  void _recomputeTotal() {
    final c = widget.borrControllers;
    final total = _toAmount(c.mortgageCtrl.text) +
        _toAmount(c.subordinateCtrl.text) +
        _toAmount(c.propertyTaxCtrl.text) +
        _toAmount(c.hoaDuesCtrl.text) +
        _toAmount(c.homeInsuranceCtrl.text) +
        _toAmount(c.mortgageInsuranceCtrl.text) +
        _toAmount(c.otherHousingCtrl.text);

    c.totalHousingExpenseCtrl.text = _fmt(total);
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.borrControllers;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(label: 'Monthly Housing Expenses'),
          const SizedBox(height: 16),
          _TwoCols(
            left: _ExpenseField(label: 'Mortgage P&I', ctrl: c.mortgageCtrl),
            right: _ExpenseField(
                label: 'Subordinate Mortgage', ctrl: c.subordinateCtrl),
          ),
          const SizedBox(height: 16),
          _TwoCols(
            left: _ExpenseField(label: 'Property Tax', ctrl: c.propertyTaxCtrl),
            right: _ExpenseField(label: 'HOA Dues', ctrl: c.hoaDuesCtrl),
          ),
          const SizedBox(height: 16),
          _TwoCols(
            left: _ExpenseField(
                label: 'Home Insurance', ctrl: c.homeInsuranceCtrl),
            right: _ExpenseField(
                label: 'Mortgage Insurance', ctrl: c.mortgageInsuranceCtrl),
          ),
          const SizedBox(height: 16),
          _ExpenseField(label: 'Other Housing', ctrl: c.otherHousingCtrl),
          const SizedBox(height: 16),
          FormTextField(
            label: 'Total Housing Expenses',
            controller: c.totalHousingExpenseCtrl,
            readOnly: true,
          ),
        ],
      ),
    );
  }
}

/* ---------------- small widgets ---------------- */

class _TwoCols extends StatelessWidget {
  final Widget left;
  final Widget right;
  const _TwoCols({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }
}

class _ExpenseField extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;

  const _ExpenseField({required this.label, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return FormTextField(
      label: label,
      controller: ctrl,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9,.\$]')),
      ],
    );
  }
}
