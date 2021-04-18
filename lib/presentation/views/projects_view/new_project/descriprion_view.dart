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

import 'package:projects/domain/controllers/projects/new_project/new_project_controller.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';

class NewProjectDescription extends StatelessWidget {
  const NewProjectDescription({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<NewProjectController>();

    return WillPopScope(
      onWillPop: () async {
        return controller.canPopBack();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: StyledAppBar(
          titleText: 'Description',
          actions: [
            IconButton(
                icon: Icon(Icons.check_outlined),
                onPressed: () => controller.confirmDescription)
          ],
        ),
        // appBar: CustomAppBar(
        //   title: CustomHeaderWithButton(
        //     function: controller.confirmDescription,
        //     title: 'Description',
        //   ),
        // ),
        body: Padding(
          padding: EdgeInsets.all(12.0),
          child: TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: controller.descriptionController,
            decoration:
                InputDecoration.collapsed(hintText: 'Enter your text here'),
          ),
        ),
      ),
    );
  }
}
