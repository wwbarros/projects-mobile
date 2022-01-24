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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class ProjectTitleTile extends StatelessWidget {
  final controller;
  final bool showCaption;
  final bool focusOnTitle;
  const ProjectTitleTile({
    Key? key,
    required this.controller,
    this.showCaption = false,
    this.focusOnTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final correctText =
        (controller.titleController as TextEditingController?)?.text.isNotEmpty ?? false
            ? true.obs
            : false.obs;

    return Padding(
      padding: EdgeInsets.only(right: 16, bottom: 10, top: showCaption ? 26 : 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: SizedBox(
              width: 72,
              child: Obx(
                () => AppIcon(
                  icon: SvgIcons.project,
                  color: correctText.value
                      ? Get.theme.colors().onBackground.withOpacity(0.75)
                      : Get.theme.colors().onBackground.withOpacity(0.4),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showCaption)
                  Text('${tr('projectTitle')}:',
                      style: TextStyleHelper.caption(
                          color: Get.theme.colors().onBackground.withOpacity(0.75))),
                Obx(
                  () => TextField(
                      onChanged: (value) {
                        if (value.isNotEmpty)
                          correctText.value = true;
                        else
                          correctText.value = false;
                      },
                      focusNode: focusOnTitle ? controller.titleFocus as FocusNode : null,
                      maxLines: null,
                      controller: controller.titleController as TextEditingController?,
                      style: TextStyleHelper.headline6(color: Get.theme.colors().onBackground),
                      cursorColor: Get.theme.colors().primary.withOpacity(0.87),
                      decoration: InputDecoration(
                          hintText: tr('projectTitle'),
                          contentPadding: EdgeInsets.zero,
                          hintStyle: TextStyleHelper.headline6(
                              color: controller.needToFillTitle.value == true
                                  ? Get.theme.colors().colorError
                                  : Get.theme.colors().onSurface.withOpacity(0.5)),
                          border: InputBorder.none)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
