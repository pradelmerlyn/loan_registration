

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_registration/presentation/loan_registration/bloc/borrower_view/borrower_view_bloc.dart';
import 'package:loan_registration/presentation/loan_registration/form_controllers/borrower_info_form_controllers.dart';
import 'package:loan_registration/presentation/widgets/dropdown_field.dart';
import 'package:loan_registration/presentation/widgets/form_textfield.dart';
import 'package:loan_registration/presentation/widgets/multivalue_input_field.dart';
import 'package:loan_registration/presentation/widgets/section_header.dart';

class PersonalInfoSection extends StatefulWidget {
  final BorrowerInfoFormControllers borrControllers;

  const PersonalInfoSection({
    super.key,
    required this.borrControllers,
  });

  @override
  State<PersonalInfoSection> createState() => _PersonalInfoSectionState();
}

class _PersonalInfoSectionState extends State<PersonalInfoSection> {
  BorrowerViewBloc? _bloc;
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _bloc ??= context.read<BorrowerViewBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BorrowerViewBloc, BorrowerViewState>(
        builder: (context, state) {
      bool isVisible = state.obscureSSN;

      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(label: 'Personal Information'),
            // SSN
            _SSNField(
              isVisible: isVisible,
              ctrl: widget.borrControllers.ssnCtrl,
            ),
            _FirstNameField(
              ctrl: widget.borrControllers.firstNameCtrl,
            ),
            _MiddleNameField(
              ctrl: widget.borrControllers.middleNameCtrl,
            ),

            _LastNameSuffixField(
              lastNameCtrl: widget.borrControllers.lastNameCtrl,
              suffixCtrl: widget.borrControllers.suffixCtrl,
            ),
            _DateOfBirthField(
              ctrl: widget.borrControllers.bdayCtrl,
            ),
            _MaritalStatusField(ctrl: widget.borrControllers.maritalStatusCtrl),
            _CitizenShipField(
              ctrl: widget.borrControllers.citizenshipCtrl,
            ),
            _DependentAgesField(
              ctrl: widget.borrControllers.dependentAgeCtrl,
            ),
          ],
        ),
      );
    });
  }
}

//** ------- FIELDS ------** /
class _SSNField extends StatelessWidget {
  final TextEditingController ctrl;
  final bool isVisible;

  const _SSNField({super.key, required this.isVisible, required this.ctrl});
  @override
  Widget build(BuildContext context) {
    final bloc = BorrowerViewBloc();
    return Column(
      children: [
        const SizedBox(height: 15),
        FormTextField(
          label: 'Social Security Number',
          controller: ctrl,
          keyboardType: TextInputType.number,
          suffixIcon: IconButton(
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                bloc.add(ToggleSSN());
              }),
          validator: (value) =>
              bloc.requiredValidator(value, 'Social Security Number'),
        ),
      ],
    );
  }
}

class _FirstNameField extends StatelessWidget {
  final TextEditingController ctrl;
  const _FirstNameField({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final bloc = BorrowerViewBloc();
    return Column(
      children: [
        const SizedBox(height: 15),
        FormTextField(
          label: 'First Name',
          controller: ctrl,
          validator: (value) => bloc.requiredValidator(value, 'First Name'),
        ),
      ],
    );
  }
}

class _MiddleNameField extends StatelessWidget {
  final TextEditingController ctrl;
  const _MiddleNameField({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final bloc = BorrowerViewBloc();
    return Column(
      children: [
        const SizedBox(height: 15),
        FormTextField(
          label: 'Middle Name',
          controller: ctrl,
          validator: (value) => bloc.requiredValidator(value, 'Middle Name'),
        ),
      ],
    );
  }
}

class _LastNameSuffixField extends StatelessWidget {
  final TextEditingController lastNameCtrl;
  final TextEditingController suffixCtrl;
  const _LastNameSuffixField(
      {
        required this.lastNameCtrl, 
        required this.suffixCtrl
      });

  @override
  Widget build(BuildContext context) {
    final bloc = BorrowerViewBloc();
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Expanded(
            child: FormTextField(
              label: 'Last Name',
              controller: lastNameCtrl,
              validator: (value) => bloc.requiredValidator(value, 'Last Name'),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 110,
            child: FormTextField(
              label: 'Suffix',
              controller: suffixCtrl,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateOfBirthField extends StatelessWidget {
  final TextEditingController ctrl;
  const _DateOfBirthField({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final bloc = BorrowerViewBloc();
    return Column(
      children: [
        const SizedBox(height: 15),
        FormTextField(
          label: 'Date of Birth',
          controller: ctrl,
          readOnly: true,
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today_rounded),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(1990, 1, 1),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                ctrl.text = '${picked.month}/${picked.day}/${picked.year}';
              }
            },
          ),
          validator: (value) => bloc.requiredValidator(value, 'Date of Birth'),
        ),
      ],
    );
  }
}

class _MaritalStatusField extends StatefulWidget {
  final TextEditingController ctrl;
  const _MaritalStatusField({super.key, required this.ctrl});

  @override
  State<_MaritalStatusField> createState() => _MaritalStatusFieldState();
}

class _MaritalStatusFieldState extends State<_MaritalStatusField> {
  @override
  Widget build(BuildContext context) {
    final bloc = BorrowerViewBloc();
    return Column(
      children: [
        const SizedBox(height: 15),
        DropDownField(
          label: "Marital Status",
          value: widget.ctrl.text.isEmpty ? null : widget.ctrl.text,
          items: const [
            DropdownMenuItem(value: "Single", child: Text("Single")),
            DropdownMenuItem(value: "Married", child: Text("Married")),
            DropdownMenuItem(value: "Divorced", child: Text("Divorced")),
            DropdownMenuItem(value: "Widowed", child: Text("Widowed")),
          ],
          onChanged: (value) {
            setState(() {
              widget.ctrl.text = value ?? '';
            });
          },
          validator: (value) =>
              value == null ? "Please select a marital status" : null,
        ),
      ],
    );
  }
}

class _CitizenShipField extends StatefulWidget {
  final TextEditingController ctrl;
  const _CitizenShipField({super.key, required this.ctrl});

  @override
  State<_CitizenShipField> createState() => _CitizenShipFieldState();
}

class _CitizenShipFieldState extends State<_CitizenShipField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        DropDownField(
          label: "What is your citrizenship status?",
          value: widget.ctrl.text.isEmpty ? null : widget.ctrl.text,
          items: const [
            DropdownMenuItem(value: "U.S Citizen", child: Text("U.S Citizen")),
            DropdownMenuItem(
                value: "Permanent Resident", child: Text("Permanent Resident")),
            DropdownMenuItem(
                value: "Non-Permanent Resident",
                child: Text("Non-Permanent Resident")),
            DropdownMenuItem(
                value: "Foreign National", child: Text("Foreign National")),
            DropdownMenuItem(value: "Other", child: Text("Other")),
          ],
          onChanged: (value) {
            setState(() {
              widget.ctrl.text = value ?? '';
            });
          },
          validator: (value) =>
              value == null ? "Please select a citizenship status" : null,
        ),
      ],
    );
  }
}

class _DependentAgesField extends StatelessWidget {
  final TextEditingController ctrl;
  const _DependentAgesField({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        MultiValueInputField(
          label: "Dependent Ages",
          controller: ctrl,
          validator: (values) {
            if (values == null || values.isEmpty) {
              return "Please enter at least one age";
            }
            // Optional: ensure all are numbers
            final nonNumeric =
                values.where((v) => int.tryParse(v) == null).toList();
            if (nonNumeric.isNotEmpty) return "Ages must be numbers";
            return null;
          },
          onChanged: (vals) {
            // vals e.g. ['12','15','18']
          },
        )
      ],
    );
  }
}

//** END Personal Info Field ** /
