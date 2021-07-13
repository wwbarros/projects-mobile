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
import 'package:projects/domain/controllers/base_sort_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class SortView extends StatelessWidget {
  const SortView({Key key, @required this.sortOptions}) : super(key: key);

  final sortOptions;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.colors().onPrimarySurface,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                height: 4,
                width: 40,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Get.theme.colors().onSurface.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2))),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 15, right: 16, top: 18.5),
              child: Text(tr('sortBy'),
                  style:
                      TextStyleHelper.h6(color: Get.theme.colors().onSurface))),
          sortOptions,
        ],
      ),
    );
  }
}

class SortTile extends StatelessWidget {
  final String sortParameter;
  final BaseSortController sortController;
  const SortTile({Key key, this.sortParameter, @required this.sortController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _selected = sortController.currentSortfilter == sortParameter;
    var title = sortController.getFilterLabel(sortParameter);

    BoxDecoration _selectedDecoration() {
      return BoxDecoration(
          color: Get.theme.colors().bgDescription,
          borderRadius: BorderRadius.circular(6));
    }

    return InkWell(
      onTap: () {
        sortController.changeSort(sortParameter);
        Get.back();
      },
      child: Container(
        height: 40,
        margin: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
        padding: const EdgeInsets.only(left: 12, right: 20),
        decoration: _selected ? _selectedDecoration() : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                      child: Text(title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyleHelper.body2()))
                ],
              ),
            ),
            if (_selected)
              AppIcon(
                  icon: sortController.isSortAscending.isTrue
                      ? SvgIcons.up_arrow
                      : SvgIcons.down_arrow)
          ],
        ),
      ),
    );
  }
}
