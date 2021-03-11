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
import 'package:only_office_mobile/data/models/project.dart';
import 'package:only_office_mobile/domain/controllers/projects_controller.dart';

import 'package:only_office_mobile/presentation/shared/app_colors.dart';
import 'package:only_office_mobile/presentation/shared/text_styles.dart';
import 'package:only_office_mobile/presentation/shared/ui_helpers.dart';
import 'package:only_office_mobile/presentation/views/projects_view/project_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProjectsController controller = Get.put(ProjectsController());

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UIHelper.verticalSpaceSmall(),
          createHeader(),
          Expanded(
            child: Obx(() => SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  controller: controller.refreshController,
                  onRefresh: controller.onRefresh,
                  onLoading: controller.onLoading,
                  child: ListView.builder(
                    itemBuilder: (c, i) =>
                        ProjectItem(project: controller.projects[i]),
                    itemExtent: 100.0,
                    itemCount: controller.projects.length,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  createHeader() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Welcome ',
            style: headerStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text('Here are all your projects', style: subHeaderStyle),
        ),
        UIHelper.verticalSpaceSmall(),
      ]);
}
