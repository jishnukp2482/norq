import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:norq/product_project/presentation/themes/app_colors.dart';

class LabelCustomTextField extends StatefulWidget {
  const LabelCustomTextField({
    super.key,
    required this.hintText,
    this.onPressed,
    this.onchanged,
    this.passwordfield,
    this.showSuffixicon,
    this.controller,
    this.inputFormatters,
    this.suffix,
    this.validator,
    this.inputType,
    this.lines,
    this.onTap,
    this.readOnly,
    this.prefix,
    this.label,
    this.labelText,
    this.enable,
    this.autofillHints,
    this.textFieldLabelColor = AppColors.black,
    required this.textFieldLabel,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool? showSuffixicon;
  final bool? enable;
  final Function? onPressed;
  final Function? onTap;
  final Function? onchanged;
  final bool? passwordfield;
  final Widget? suffix;
  final Function(String)? validator;
  final TextInputType? inputType;
  final int? lines;
  final Widget? prefix;
  final bool? readOnly;
  final Widget? label;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final String textFieldLabel;
  final Color? textFieldLabelColor;

  @override
  State<LabelCustomTextField> createState() => _LabelCustomTextField();
}

class _LabelCustomTextField extends State<LabelCustomTextField> {
  bool showpassword = true;
  late bool showPrefixIcon;

  @override
  void initState() {
    showPrefixIcon = widget.showSuffixicon ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.textFieldLabel,
              style: GoogleFonts.poppins(
                  color: widget.textFieldLabelColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400)),
          SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(15),
              shape: BoxShape.rectangle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            width: w,
            child: TextFormField(
              autofillHints: widget.autofillHints,
              inputFormatters: widget.inputFormatters,
              onChanged: (value) {
                if (widget.onchanged != null) {
                  widget.onchanged!(value);
                }
              },
              controller: widget.controller,
              validator: widget.validator == null
                  ? null
                  : (val) => widget.validator!(val ?? ""),
              obscureText: widget.passwordfield == true ? showpassword : false,
              keyboardType: widget.inputType ?? TextInputType.text,
              maxLines: widget.passwordfield == true ? 1 : widget.lines,
              decoration: InputDecoration(
                  filled: true,
                  label: widget.label,
                  labelText: widget.labelText,
                  labelStyle: const TextStyle(),
                  fillColor: AppColors.white,
                  prefixIcon: showPrefixIcon ? widget.prefix : null,
                  suffixIcon: widget.passwordfield == true
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              showpassword = !showpassword;
                            });
                          },
                          icon: showpassword
                              ? Icon(
                                  Ionicons.eye_off,
                                  size: 20,
                                  color: Theme.of(context).primaryColor,
                                )
                              : Icon(
                                  Icons.remove_red_eye,
                                  color: Theme.of(context).primaryColor,
                                ))
                      : widget.suffix,
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(
                    color: AppColors.greyText,
                    width: 0.3,
                  )),
                  hintText: widget.hintText,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 0.3,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                    color: AppColors.greyText,
                    width: 0.3,
                  )),
                  disabledBorder: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.all(15),
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
