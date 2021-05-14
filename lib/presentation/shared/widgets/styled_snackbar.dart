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
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

// TODO shared snackBar
SnackBar styledSnackBar({
  @required BuildContext context,
  @required String text,
  String buttonText,
  Function() buttonOnTap,
}) {
  return SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(text)),
        if (buttonText != null && buttonText.isNotEmpty)
          GestureDetector(
            onTap: buttonOnTap,
            child: SizedBox(
              height: 16,
              width: 65,
              child: Center(
                child: Text(
                  buttonText,
                  style: TextStyleHelper.button(
                          color: Theme.of(context)
                              .customColors()
                              .primary
                              .withOpacity(0.5))
                      .copyWith(height: 1),
                ),
              ),
            ),
          ),
        if (buttonText == null)
          GestureDetector(
            onTap: () =>
                ScaffoldMessenger.maybeOf(context).hideCurrentSnackBar(),
            child: SizedBox(
              height: 16,
              width: 65,
              child: Center(
                child: Text('OK',
                    style: TextStyleHelper.button(
                            color: Theme.of(context)
                                .customColors()
                                .primary
                                .withOpacity(0.5))
                        .copyWith(height: 1)),
              ),
            ),
          ),
      ],
    ),
    backgroundColor: Theme.of(context).customColors().snackBarColor,
    padding: const EdgeInsets.only(top: 2, bottom: 2, left: 16, right: 10),
    margin: const EdgeInsets.only(left: 8, right: 8, bottom: 9),
    behavior: SnackBarBehavior.floating,
  );
}