import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_project/feature/shared/utils/styles/app_color.dart';
import 'package:flutter_project/feature/shared/utils/styles/app_text_style.dart';

class SharedAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const SharedAppBar({
    super.key,
    this.title,
    this.isShowBackButton = false,
    this.actions,
    this.leadingIcon,
    this.centerTitle = true,
    this.titleText,
    this.showUserIcon = false,
    this.showTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.textColor,
    this.textStyle,
    this.backButtonColor,
    this.bottom,
  });

  final String? title;
  final bool isShowBackButton;
  final List<Widget>? actions;
  final Widget? leadingIcon;
  final bool centerTitle;
  final String? titleText;
  final bool showUserIcon;
  final bool showTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final Color? backButtonColor;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  ConsumerState<SharedAppBar> createState() => _SharedAppBarState();
}

class _SharedAppBarState extends ConsumerState<SharedAppBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        backgroundColor: widget.backgroundColor ?? context.color.whiteColor,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        automaticallyImplyLeading: false,
        centerTitle: widget.centerTitle,
        leading: widget.isShowBackButton
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: widget.backButtonColor ?? context.color.blackColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
        title: widget.showTitle
            ? Text(
                widget.title ?? widget.titleText ?? "",
                style:
                    widget.textStyle ??
                    AppTextStyle.titleLarge.copyWith(
                      color: widget.textColor ?? context.color.blackColor,
                      fontWeight: FontWeight.w700,
                    ),
                overflow: TextOverflow.ellipsis,
              )
            : const SizedBox.shrink(),
        actions: widget.actions,
      ),
    );
  }
}
