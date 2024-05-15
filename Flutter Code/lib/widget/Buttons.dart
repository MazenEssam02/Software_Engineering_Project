import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  String title;
  void Function()? onPressed;
  bool isloading;
  Color foregroundColor, backgroundColor;
  double? fontsize;
  double? width;
  double? height;
  double? borderRadius;

  PrimaryButton(
      {required this.title,
      this.width,
      this.onPressed,
      required this.foregroundColor,
      required this.backgroundColor,
      this.fontsize,
      this.height,
      this.borderRadius,
      required this.isloading});
  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isloading ? null : widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius:
                BorderRadius.circular(widget.borderRadius ?? widget.height!)),
        height: widget.height ?? 50,
        width: widget.width ?? MediaQuery.of(context).size.width,
        child: Center(
          child: widget.isloading
              ? Center(
                  child: Container(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        widget.foregroundColor),
                    backgroundColor: widget.backgroundColor,
                  ),
                ))
              : Text(
                  widget.title,
                  style: TextStyle(
                      color: widget.foregroundColor,
                      fontSize: widget.fontsize == null ? 24 : widget.fontsize,
                      fontWeight: FontWeight.w700),
                ),
        ),
      ),
    );
  }
}
