// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../table_calendar.dart';
import '../customization/calendar_builders.dart';
import '../customization/calendar_style.dart';

class CellContent extends StatelessWidget {
  final DateTime day;
  final DateTime focusedDay;
  final CalendarFormat format;
  final dynamic locale;
  final bool isTodayHighlighted;
  final bool isToday;
  final bool isSelected;
  final bool isRangeStart;
  final bool isRangeEnd;
  final bool isWithinRange;
  final bool isOutside;
  final bool isDisabled;
  final bool isHoliday;
  final bool isWeekend;
  final CalendarStyle calendarStyle;
  final CalendarBuilders calendarBuilders;

  const CellContent({
    Key? key,
    required this.day,
    required this.focusedDay,
    required this.format,
    required this.calendarStyle,
    required this.calendarBuilders,
    required this.isTodayHighlighted,
    required this.isToday,
    required this.isSelected,
    required this.isRangeStart,
    required this.isRangeEnd,
    required this.isWithinRange,
    required this.isOutside,
    required this.isDisabled,
    required this.isHoliday,
    required this.isWeekend,
    this.locale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dowLabel = DateFormat.EEEE(locale).format(day);
    final dayLabel = DateFormat.yMMMMd(locale).format(day);
    final semanticsLabel = '$dowLabel, $dayLabel';

    Widget? cell = calendarBuilders.prioritizedBuilder?.call(context, day, focusedDay);

    if (cell != null) {
      return Semantics(
        label: semanticsLabel,
        excludeSemantics: true,
        child: cell,
      );
    }

    final text = '${day.day}';
    final margin = format == CalendarFormat.week ? calendarStyle.cellMargin : EdgeInsets.all(6.0);
    final padding = calendarStyle.cellPadding;
    final alignment = calendarStyle.cellAlignment;
    final duration = const Duration(milliseconds: 250);

    if (isDisabled) {
      cell = Column(
        children: [
          calendarBuilders.disabledBuilder?.call(context, day, focusedDay) ??
              Container(
                child: format == CalendarFormat.week
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 5.0, left: 16.0, right: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: isWeekend ? const Color(0xFF7AC74F) : const Color(0xFF706BEE),
                          ),
                          height: 2,
                        ),
                      )
                    : Container(),
              ),
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.disabledDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.disabledTextStyle),
          ),
        ],
      );
    } else if (isSelected) {
      cell = calendarBuilders.selectedBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.selectedDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.selectedTextStyle),
          );
    } else if (isRangeStart) {
      cell = Column(
        children: [
          calendarBuilders.rangeStartBuilder?.call(context, day, focusedDay) ??
              Container(
                child: format == CalendarFormat.week
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 5.0, left: 16.0, right: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: isWeekend ? const Color(0xFF7AC74F) : const Color(0xFF706BEE),
                          ),
                          height: 2,
                        ),
                      )
                    : Container(),
              ),
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.rangeStartDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.rangeStartTextStyle),
          ),
        ],
      );
    } else if (isRangeEnd) {
      cell = Column(
        children: [
          calendarBuilders.rangeEndBuilder?.call(context, day, focusedDay) ??
              Container(
                child: format == CalendarFormat.week
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 5.0, left: 16.0, right: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: isWeekend ? const Color(0xFF7AC74F) : const Color(0xFF706BEE),
                          ),
                          height: 2,
                        ),
                      )
                    : Container(),
              ),
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.rangeEndDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.rangeEndTextStyle),
          ),
        ],
      );
    } else if (isToday && isTodayHighlighted) {
      cell = Padding(
        padding: const EdgeInsets.all(5.0),
        child: DottedBorder(
          color: const Color(0xFF3057FA),
          borderType: BorderType.Circle,
          radius: Radius.circular(200),
          padding: EdgeInsets.all(4.0),
          child: calendarBuilders.todayBuilder?.call(context, day, focusedDay) ??
              AnimatedContainer(
                duration: duration,
                decoration: calendarStyle.todayDecoration,
                alignment: alignment,
                child: Text(text, style: calendarStyle.todayTextStyle),
              ),
        ),
      );
    } else if (isHoliday) {
      cell = Column(
        children: [
          calendarBuilders.holidayBuilder?.call(context, day, focusedDay) ??
              Container(
                child: format == CalendarFormat.week
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 5.0, left: 16.0, right: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: isWeekend ? const Color(0xFF7AC74F) : const Color(0xFF706BEE),
                          ),
                          height: 2,
                        ),
                      )
                    : Container(),
              ),
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.holidayDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.holidayTextStyle),
          ),
        ],
      );
    } else if (isWithinRange) {
      cell = Column(
        children: [
          calendarBuilders.withinRangeBuilder?.call(context, day, focusedDay) ??
              Container(
                child: format == CalendarFormat.week
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 5.0, left: 16.0, right: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: isWeekend ? const Color(0xFF7AC74F) : const Color(0xFF706BEE),
                          ),
                          height: 2,
                        ),
                      )
                    : Container(),
              ),
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.withinRangeDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.withinRangeTextStyle),
          ),
        ],
      );
    } else if (isOutside) {
      cell = Column(
        children: [
          calendarBuilders.outsideBuilder?.call(context, day, focusedDay) ??
              Container(
                child: format == CalendarFormat.week
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 5.0, left: 16.0, right: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: isWeekend ? const Color(0xFF7AC74F) : const Color(0xFF706BEE),
                          ),
                          height: 2,
                        ),
                      )
                    : Container(),
              ),
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.outsideDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.outsideTextStyle),
          ),
        ],
      );
    } else {
      cell = Column(
        children: [
          calendarBuilders.defaultBuilder?.call(context, day, focusedDay) ??
              Container(
                child: format == CalendarFormat.week
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 5.0, left: 16.0, right: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: isWeekend ? const Color(0xFF7AC74F) : const Color(0xFF706BEE),
                          ),
                          height: 2,
                        ),
                      )
                    : Container(),
              ),
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: isWeekend ? calendarStyle.weekendDecoration : calendarStyle.defaultDecoration,
            alignment: alignment,
            child: Text(
              text,
              style: isWeekend ? calendarStyle.weekendTextStyle : calendarStyle.defaultTextStyle,
            ),
          ),
        ],
      );
    }

    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child: cell,
    );
  }
}
