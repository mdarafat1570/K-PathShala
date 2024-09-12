import 'package:kpathshala/app_base/common_imports.dart';

Widget customTextField({
  required TextEditingController controller,
  required String label,
  String? hintText,
  String? errorMessage,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
  ValueChanged<String>? onChanged,
  double? width,
  double? height,
}) {
  return SizedBox(
    width: width,
    height: height,
    child: TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        errorText: errorMessage,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: errorMessage == null ? Colors.grey : Colors.red,
            width: 0.1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: errorMessage == null ? Colors.blue : Colors.red,
            width: 0.1,
          ),
        ),
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      ),
    ),
  );
}
