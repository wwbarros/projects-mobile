import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/wrappers/platform.dart';

class PlatformPopupMenuItem<T> extends PopupMenuEntry<T> {
  const PlatformPopupMenuItem({
    Key? key,
    this.value,
    this.onTap,
    this.enabled = true,
    this.height = kMinInteractiveDimension,
    this.padding,
    this.textStyle,
    this.mouseCursor,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    this.trailingIcon,
    required this.child,
  })  : assert(
          !(value != null && onTap != null),
          'You can only pass [value] or [onTap], not both.',
        ),
        super(key: key);

  final T? value;
  final VoidCallback? onTap;

  final bool enabled;

  @override
  final double height;

  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final MouseCursor? mouseCursor;
  final Widget? child;

  final bool isDefaultAction;
  final bool isDestructiveAction;
  final IconData? trailingIcon;

  @override
  bool represents(T? value) => value == this.value;

  @override
  MyPopupMenuItemState<T, PlatformPopupMenuItem<T>> createState() =>
      MyPopupMenuItemState<T, PlatformPopupMenuItem<T>>();
}

class MyPopupMenuItemState<T, W extends PlatformPopupMenuItem<T>> extends State<W> {
  final double _kMenuHorizontalPadding = 16;
  final Color _kBackgroundColor = Get.isDarkMode
      ? const Color.fromRGBO(37, 37, 37, 0.5)
      : const Color.fromRGBO(237, 237, 237, 0.9);
  final Color _kBackgroundColorPressed = Get.isDarkMode
      ? const Color.fromRGBO(37, 37, 37, 0.8)
      : const Color.fromRGBO(216, 216, 216, 1);
  final double _kButtonHeight = 44;
  final TextStyle _kActionSheetActionStyle = TextStyle(
    fontFamily: '.SF Pro Text',
    fontSize: 17,
    color: Get.theme.colors().onSurface,
    fontWeight: FontWeight.w400,
    height: 1.3,
    letterSpacing: -0.41,
  );

  final GlobalKey _globalKey = GlobalKey();
  bool _isPressed = false;

  void onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @protected
  Widget? buildChild() => widget.child;

  @protected
  void handleTap() {
    if (widget.enabled) widget.onTap?.call();

    if (widget.onTap == null && widget.value != null) Navigator.pop<T>(context, widget.value);
  }

  TextStyle get _textStyle {
    if (widget.isDefaultAction) {
      return _kActionSheetActionStyle.copyWith(
        fontWeight: FontWeight.w600,
      );
    }
    if (widget.isDestructiveAction) {
      return _kActionSheetActionStyle.copyWith(
        color: CupertinoColors.destructiveRed,
      );
    }
    return _kActionSheetActionStyle;
  }

  Widget createCupertinoWidget(BuildContext context) {
    return GestureDetector(
      key: _globalKey,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onTap: handleTap,
      behavior: HitTestBehavior.opaque,
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(height: _kButtonHeight),
        child: Semantics(
          button: true,
          child: Container(
            decoration: BoxDecoration(
              color: widget.enabled
                  ? _isPressed
                      ? _kBackgroundColorPressed
                      : _kBackgroundColor.withOpacity(0.4)
                  : CupertinoColors.inactiveGray,
            ),
            padding: EdgeInsets.symmetric(horizontal: _kMenuHorizontalPadding),
            child: DefaultTextStyle(
              style: _textStyle,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: widget.child!,
                  ),
                  if (widget.trailingIcon != null)
                    Icon(
                      widget.trailingIcon,
                      color: _textStyle.color,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget createMaterialWidget(BuildContext context) {
    final theme = Theme.of(context);
    final popupMenuTheme = PopupMenuTheme.of(context);
    var style = widget.textStyle ?? popupMenuTheme.textStyle ?? theme.textTheme.subtitle1!;

    if (!widget.enabled) style = style.copyWith(color: theme.disabledColor);

    Widget item = AnimatedDefaultTextStyle(
      style: style,
      duration: kThemeChangeDuration,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        constraints: BoxConstraints(minHeight: widget.height),
        padding: widget.padding ?? EdgeInsets.symmetric(horizontal: _kMenuHorizontalPadding),
        child: buildChild(),
      ),
    );

    if (!widget.enabled) {
      final isDark = theme.brightness == Brightness.dark;
      item = IconTheme.merge(
        data: IconThemeData(opacity: isDark ? 0.5 : 0.38),
        child: item,
      );
    }
    final effectiveMouseCursor = MaterialStateProperty.resolveAs<MouseCursor>(
      widget.mouseCursor ?? MaterialStateMouseCursor.clickable,
      <MaterialState>{
        if (!widget.enabled) MaterialState.disabled,
      },
    );

    return MergeSemantics(
      child: Semantics(
        enabled: widget.enabled,
        button: true,
        child: InkWell(
          onTap: widget.enabled ? handleTap : null,
          canRequestFocus: widget.enabled,
          mouseCursor: effectiveMouseCursor,
          child: item,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isMaterial(context)) {
      return createMaterialWidget(context);
    } else if (isCupertino(context)) {
      return createCupertinoWidget(context);
    }

    return throw UnsupportedError('This platform is not supported');
  }
}
