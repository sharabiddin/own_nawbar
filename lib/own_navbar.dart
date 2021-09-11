library own_navbar;

import 'dart:math';

import 'package:flutter/material.dart';

enum IndicatorTypes {
  ULTRASMALL,
  SMALL,
  MEDIUM,
  LARGE,
  MAX,
}

class NavBarItem {
  String? elementName;
  String navigationId;
  IconData? elementIcon;
  double portion = 1;

  NavBarItem(
      {this.elementName,
      this.elementIcon,
      this.portion = 1,
      required this.navigationId})
      : assert(!(elementIcon == null && elementName == null));
}

// ignore: must_be_immutable
class BottomNavbar extends StatefulWidget {
  final double height;
  double? indicatorHeight;
  IndicatorTypes indicatorType;
  int animationDuration;
  Color? indicatorColor;
  TextStyle? textStyle;
  List<NavBarItem> navItems;
  Color passiveColor;

  Color backgroundColor;
  Color activeColor;
  Cubic curve;
  Function(int, String) itemClicked;
  EdgeInsets padding;

  bool equalDuration;
  bool showIndicator;

  BottomNavbar({
    Key? key,
    required this.navItems,
    required this.itemClicked,
    this.animationDuration = 100,
    this.equalDuration = true,
    this.showIndicator = true,
    this.indicatorColor,
    this.indicatorHeight,
    this.padding = EdgeInsets.zero,
    this.textStyle,
    this.backgroundColor = Colors.white,
    this.activeColor = Colors.black,
    this.passiveColor = Colors.black54,
    this.curve = Curves.easeOut,
    this.indicatorType = IndicatorTypes.MAX,
    required this.height,
  })  : assert(navItems.length != 0),
        assert(animationDuration > 0),
        super(key: key);

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int initialIndex = 0;
  int initialDuration = 0;

  @override
  void initState() {
    initialDuration = widget.animationDuration;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: widget.padding,
      color: widget.backgroundColor,
      child: Stack(
        children: [
          widget.showIndicator
              ? AnimatedContainer(
                  alignment: Alignment(xCoordinate(), -1),
                  duration: Duration(milliseconds: initialDuration),
                  curve: widget.curve,
                  child: Container(
                    color: Colors.transparent,
                    width: indicatorWidth(),
                    alignment: Alignment(0, -1),
                    child: Container(
                      width: indicatorWidth() / indicatorSizeFactor(),
                      height: widget.indicatorHeight ?? widget.height / 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(indicatorWidth()),
                        color: colorReturner(),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
          Container(
            alignment: Alignment.center,
            margin: widget.showIndicator
                ? EdgeInsets.only(
                    top: widget.indicatorHeight ?? widget.height / 10)
                : EdgeInsets.zero,
            child: Row(
              children: [
                for (int i = 0; i < lengthReturner(); i++) ...{
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        if (initialIndex == i) {
                          return;
                        }
                        if (widget.equalDuration) {
                          initialDuration = ((initialIndex - i).abs() *
                                  widget.animationDuration)
                              .round();
                        }

                        setState(() {
                          initialIndex = i;
                        });
                        widget.itemClicked.call(
                            initialIndex, widget.navItems[i].navigationId);
                      },
                      child: Center(
                        child: NavItem(i),
                      ),
                    ),
                  ),
                },
              ],
            ),
          )
        ],
      ),
    );
  }

  xCoordinate() {
    double k = 1;

    k = 2 / (widget.navItems.length - 1);

    double y = (k * initialIndex) - 1;

    return y;
  }

  Color colorReturner() {
    if (widget.indicatorColor != null) {
      return widget.indicatorColor!;
    }
    return Color.fromRGBO(
        Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1);
  }

  double indicatorWidth() {
    return MediaQuery.of(context).size.width / widget.navItems.length;
  }

  // ignore: non_constant_identifier_names
  Widget NavItem(int i) {
    if (widget.navItems[i].elementName != null &&
        widget.navItems[i].elementIcon != null) {
      return Column(
        children: [
          Icon(
            widget.navItems[i].elementIcon,
            color: initialIndex == i ? widget.activeColor : widget.passiveColor,
            size: initialIndex == i ? widget.height / 1.8 : widget.height / 2,
          ),
          Text(
            widget.navItems[i].elementName!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: widget.textStyle != null
                ? widget.textStyle!.copyWith(
                    color: initialIndex == i
                        ? widget.activeColor
                        : widget.passiveColor,
                    fontSize: initialIndex == i
                        ? widget.textStyle!.fontSize! + 2
                        : widget.textStyle!.fontSize,
                  )
                : TextStyle(
                    color: initialIndex == i
                        ? widget.activeColor
                        : widget.passiveColor,
                    fontSize: initialIndex == i
                        ? widget.height / 5
                        : widget.height / 6,
                  ),
          ),
        ],
      );
    } else if (widget.navItems[i].elementName != null) {
      return Text(
        widget.navItems[i].elementName!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: widget.textStyle != null
            ? widget.textStyle!.copyWith(
                color: initialIndex == i
                    ? widget.activeColor
                    : widget.passiveColor,
                fontSize: initialIndex == i
                    ? widget.textStyle!.fontSize! + 2
                    : widget.textStyle!.fontSize,
              )
            : TextStyle(
                color: initialIndex == i
                    ? widget.activeColor
                    : widget.passiveColor,
                fontSize: initialIndex == i ? 13 : 11,
              ),
      );
    } else
      return Icon(
        widget.navItems[i].elementIcon,
        color: initialIndex == i ? widget.activeColor : widget.passiveColor,
        size: initialIndex == i ? widget.height / 1.2 : widget.height / 1.5,
      );
  }

  num lengthReturner() {
    return widget.navItems.length;
  }

  num indicatorSizeFactor() {
    int factor = 1;
    switch (widget.indicatorType) {
      case IndicatorTypes.ULTRASMALL:
        factor = 15;
        break;
      case IndicatorTypes.SMALL:
        factor = 5;
        break;

      case IndicatorTypes.MEDIUM:
        factor = 3;
        break;
      case IndicatorTypes.LARGE:
        factor = 2;
        break;
      case IndicatorTypes.MAX:
        factor = 1;
        break;
    }
    return factor;
  }
}
