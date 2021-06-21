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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/customBottomSheet.dart';
import 'package:projects/presentation/shared/widgets/status_tile.dart';

Future<void> showsDiscussionStatusesBS({
  context,
  DiscussionItemController controller,
}) async {
  var initSize = _getInititalSize();
  showCustomBottomSheet(
    context: context,
    headerHeight: 60,
    initHeight: initSize,
    maxHeight: initSize + 0.1,
    decoration: BoxDecoration(
        color: Theme.of(context).customColors().onPrimarySurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
    headerBuilder: (context, bottomSheetOffset) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18.5),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text('Select status',
                style: TextStyleHelper.h6(
                    color: Theme.of(context).customColors().onSurface)),
          ),
          const SizedBox(height: 18.5),
        ],
      );
    },
    builder: (context, bottomSheetOffset) {
      return SliverChildListDelegate(
        [
          // Obx(
          //   () =>
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    width: 1,
                    color: Theme.of(context)
                        .customColors()
                        .outline
                        .withOpacity(0.5)),
              ),
            ),
            child: Obx(
              () => Column(
                children: [
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () async => controller.updateMessageStatus(0),
                    child: StatusTile(
                      title: 'Open',
                      selected: controller.status.value == 0,
                    ),
                  ),
                  InkWell(
                    onTap: () async => controller.updateMessageStatus(1),
                    child: StatusTile(
                      title: 'Archived',
                      selected: controller.status.value == 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          // ),
        ],
      );
    },
  );
}

double _getInititalSize() => 180 / Get.height;