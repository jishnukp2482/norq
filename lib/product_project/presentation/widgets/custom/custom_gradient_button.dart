import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomGradientButton extends StatefulWidget {
  CustomGradientButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.buttonFColor,
    this.buttonSColor,
    this.buttonTColor,
    this.textColor,
    this.width,
    this.height,
    this.boxShadow = true,
    this.titleFontSize,
    this.uppercase = true,
  }) : super(key: key);

  final String title;
  final Function onPressed;
  final Color? buttonTColor;
  final Color? buttonSColor;
  final Color? buttonFColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? titleFontSize;
  bool uppercase;
  bool boxShadow;
  @override
  State<CustomGradientButton> createState() => _CustomGradientButtonState();
}

class _CustomGradientButtonState extends State<CustomGradientButton> {
  bool isclicked = false;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    return SizedBox(
      width: widget.width ?? w * 0.88,
      height: widget.height ?? h * 0.06,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isclicked = !isclicked;
          });
          widget.onPressed();
        },
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          decoration: BoxDecoration(
            gradient:
                // isclicked?
                LinearGradient(
              begin: isclicked ? Alignment.centerLeft : Alignment.centerRight,
              end: isclicked ? Alignment.centerRight : Alignment.centerLeft,
              // begin: Alignment.centerRight,
              // end: Alignment.centerLeft,
              colors: [
                widget.buttonFColor ?? Theme.of(context).primaryColor,
                widget.buttonSColor ?? Theme.of(context).primaryColorLight,
                widget.buttonTColor ?? Theme.of(context).primaryColorDark,
                //         widget.buttonFColor ?? Theme.of(context).primaryColor,
                // widget.buttonSColor ?? Theme.of(context).primaryColor,
                // widget.buttonTColor ?? Theme.of(context).primaryColor,
              ],
            ),
            // : LinearGradient(
            //     begin: Alignment.centerLeft,
            //     end: Alignment.centerRight,
            //     colors: [
            //       widget.buttonFColor ?? Theme.of(context).primaryColor,
            //       widget.buttonSColor ??
            //           Theme.of(context).primaryColorLight,
            //       widget.buttonTColor ?? Theme.of(context).primaryColorDark,
            //     ],
            //   ),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: widget.boxShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              widget.uppercase ? widget.title.toUpperCase() : widget.title,
              style: GoogleFonts.poppins(
                color: widget.textColor ?? Colors.white,
                fontSize: widget.titleFontSize ?? 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
