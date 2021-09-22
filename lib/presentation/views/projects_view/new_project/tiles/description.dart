/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'dart:ui' as _ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/views/projects_view/new_project/description_view.dart';

class ProjectDescriptionTile extends StatefulWidget {
  final controller;
  ProjectDescriptionTile({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  _ProjectDescriptionTileState createState() => _ProjectDescriptionTileState();
}

class _ProjectDescriptionTileState extends State<ProjectDescriptionTile>
    with TickerProviderStateMixin {
  bool _isExpanded;

  AnimationController _animationController;

  final Animatable<double> _halfTween = Tween<double>(begin: 0, end: 0.245);
  final Animatable<double> _turnsTween = CurveTween(curve: Curves.easeIn);

  Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _isExpanded = false;
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    _iconTurns = _animationController.drive(_halfTween.chain(_turnsTween));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: omit_local_variable_types
    double _height = _isExpanded ? null : 61;

    void changeExpansion() {
      setState(() {
        _isExpanded = !_isExpanded;
        if (_isExpanded) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      });
    }

    return Obx(
      () {
        // ignore: omit_local_variable_types
        bool _isNotEmpty = widget.controller.descriptionText.value.isNotEmpty;
        var _color = _isNotEmpty
            ? Get.theme.colors().onBackground
            : Get.theme.colors().onBackground.withOpacity(0.4);
        var text = widget.controller.descriptionText.value;
        var textSize = _textSize(text, TextStyleHelper.subtitle1());

        return InkWell(
          onTap: () => Get.find<NavigationController>().toScreen(
              const NewProjectDescription(),
              arguments: {'controller': widget.controller}),
          child: Column(
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                vsync: this,
                child: SizedBox(
                  height: _height,
                  child: Row(
                    children: [
                      SizedBox(
                          width: 72,
                          child: AppIcon(
                              icon: SvgIcons.description, color: _color)),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: _isNotEmpty ? 10 : 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_isNotEmpty)
                                Text('${tr('description')}:',
                                    style: TextStyleHelper.caption(
                                        color: Get.theme
                                            .colors()
                                            .onBackground
                                            .withOpacity(0.75))),
                              Flexible(
                                child: Text(
                                    _isNotEmpty ? text : tr('addDescription'),
                                    style: TextStyleHelper.subtitle1(
                                        color: _color)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_needToExpand(textSize.width, text))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5, right: 13),
                              child: IconButton(
                                icon: RotationTransition(
                                  turns: _iconTurns,
                                  child: Icon(
                                    Icons.navigate_next,
                                    size: 24,
                                    color: Get.theme.colors().onBackground,
                                  ),
                                ),
                                onPressed: changeExpansion,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const StyledDivider(leftPadding: 72),
            ],
          ),
        );
      },
    );
  }
}

Size _textSize(String text, TextStyle style) {
  final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: _ui.TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

bool _needToExpand(double size, String text) {
  var freeSize = Get.width - 72 - 59;
  if ('\n'.allMatches(text).length + 1 > 1) return true;
  if (freeSize > size) return false;
  return true;
}