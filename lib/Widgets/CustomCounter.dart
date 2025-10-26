import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';

class DecimalNumberPickerField extends StatefulWidget {
  final String? initialValue;
  final bool isEdit;
  final String? suffix;
  final ValueChanged<String> onChanged;

  const DecimalNumberPickerField({
    super.key,
    this.initialValue,
    this.isEdit = true,
    this.suffix,
    required this.onChanged,
  });

  @override
  State<DecimalNumberPickerField> createState() =>
      _DecimalNumberPickerFieldState();
}

class _DecimalNumberPickerFieldState extends State<DecimalNumberPickerField> {
  late String _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? "0.0";
  }

  void _showPicker() {
    Picker(
      adapter: NumberPickerAdapter(
        data: [
          NumberPickerColumn(begin: 0, end: 100), // integer part
          NumberPickerColumn(begin: 0, end: 9), // decimal part
        ],
      ),
      delimiter: [
        PickerDelimiter(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: const Text("."), // dot between numbers
          ),
        ),
      ],
      selecteds: [
        int.tryParse(_value.split(".")[0]) ?? 0,
        int.tryParse(_value.split(".")[1]) ?? 0,
      ],
      hideHeader: true,
      onConfirm: (picker, values) {
        final result = "${values[0]}.${values[1]}";
        setState(() => _value = result);
        widget.onChanged(result);
      },
    ).showDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isEdit ? _showPicker : null,
      child: AbsorbPointer(
        absorbing: true,
        child: TextFormField(
          enabled: widget.isEdit,
          controller: TextEditingController(text: _value),
          textAlign: TextAlign.center,
          readOnly: true,
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.blue),
            ),
            suffixText: widget.suffix ?? '',
          ),
        ),
      ),
    );
  }
}
