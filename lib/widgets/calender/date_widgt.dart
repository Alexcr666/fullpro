import 'package:calender_picker/gestures/tap.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fullpro/widgets/calender/DatePicker.dart';
import 'package:fullpro/styles/statics.dart' as _static;

class DateWidget extends StatefulWidget {
  final double? width;
  final DateTime date;
  final TextStyle? monthTextStyle, dayTextStyle, dateTextStyle;
  final Color selectionColor;
  final Color selectionBorderColor;
  final Color activeColor;
  final TextStyle activeDayStyle;
  final TextStyle activeDateStyle;
  final MultiSelectionListener? multiSelectionListener;
  final DateSelectionCallback? onDateSelected;
  final bool isMultiSelectionEnable;
  final String? locale;

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  DateWidget({
    required this.date,
    required this.monthTextStyle,
    required this.dayTextStyle,
    required this.activeDateStyle,
    this.multiSelectionListener,
    required this.activeDayStyle,
    required this.activeColor,
    required this.isMultiSelectionEnable,
    required this.dateTextStyle,
    required this.selectionColor,
    required this.selectionBorderColor,
    this.width,
    this.onDateSelected,
    this.locale,
  });

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> with AutomaticKeepAliveClientMixin {
  bool isSelect = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return InkWell(
      child: Container(
        width: 65,
        margin: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          border: Border.all(
            width: isSelect == false ? 1 : 1,
            color: widget.isMultiSelectionEnable == true
                ? isSelect == false
                    ? _static.themeColor[500]!
                    : widget.activeColor
                : widget.selectionBorderColor,
          ),
          color: widget.isMultiSelectionEnable == true
              ? isSelect == false
                  ? widget.selectionColor
                  : widget.activeColor
              : widget.selectionColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                DateFormat("E", widget.locale).format(widget.date).toUpperCase(),
                style: widget.isMultiSelectionEnable == true
                    ? isSelect == false
                        ? widget.dayTextStyle
                        : widget.activeDayStyle
                    : widget.dayTextStyle,
              ),
              Text(
                widget.date.day.toString(), // Date
                style: widget.isMultiSelectionEnable == true
                    ? isSelect == false
                        ? widget.dateTextStyle
                        : widget.activeDateStyle
                    : widget.dateTextStyle,
              ),
              Text(
                DateFormat("MMM", widget.locale).format(widget.date).toUpperCase(),
                style: widget.isMultiSelectionEnable == true
                    ? isSelect == false
                        ? widget.dayTextStyle
                        : widget.activeDayStyle
                    : widget.dayTextStyle,
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        if (widget.isMultiSelectionEnable == true) {
          setState(() {
            isSelect = !isSelect;

            if (isSelect == true) {
              list.add(widget.date.toString());
              if (widget.onDateSelected != null) {
                // Call the onDateSelected Function
                widget.multiSelectionListener!(list);
              }
            } else {
              list.remove(widget.date.toString());
              // ignore: avoid_print
              if (widget.onDateSelected != null) {
                // Call the onDateSelected Function
                widget.multiSelectionListener!(list);
              }
            }
          });
        } else {
          // Check if onDateSelected is not null
          if (widget.onDateSelected != null) {
            // Call the onDateSelected Function
            widget.onDateSelected!(widget.date);
          }
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
