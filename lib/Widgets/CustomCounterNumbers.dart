import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';

class NumberPickerField extends StatefulWidget {
  final String? initialValue;
  final bool isEdit;
  final String? suffix;
  final ValueChanged<String> onChanged;

  const NumberPickerField({
    super.key,
    this.initialValue,
    required this.isEdit,
    this.suffix,
    required this.onChanged,
  });

  @override
  State<NumberPickerField> createState() => _NumberPickerFieldState();
}

class _NumberPickerFieldState extends State<NumberPickerField> {
  late String _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? "0";
  }

  void _showPicker() {
    Picker(
      adapter: NumberPickerAdapter(
        data: [
          NumberPickerColumn(begin: 0, end: 100), // integer part
        ],
      ),
      selecteds: [int.tryParse(_value.split(".")[0]) ?? 0],
      hideHeader: true,
      onConfirm: (picker, values) {
        final result = "${values[0]}";
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
            // isDense: true,
            border: InputBorder.none, // 🔹 removes border
            suffixIcon: Column(
              children: [
                const Icon(
                  // Icons.arrow_right_rounded, // 🔹 dropdown arrow
                  Icons.arrow_drop_up, // 🔹 dropdown arrow
                  color: Colors.grey,
                ),
                const Icon(
                  // Icons.arrow_right_rounded, // 🔹 dropdown arrow
                  Icons.arrow_drop_down, // 🔹 dropdown arrow
                  color: Colors.grey,
                ),
              ],
            ),
            // prefixIcon: const Icon(
            //   Icons.arrow_left_rounded, // 🔹 dropdown arrow
            //   color: Colors.grey,
            // ),
          ),
        ),
      ),
    );
  }
}
