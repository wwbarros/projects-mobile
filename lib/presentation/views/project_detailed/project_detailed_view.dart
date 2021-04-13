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
import 'package:projects/domain/controllers/projects/project_cell_controller.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/views/project_detailed/custom_appbar.dart';
import 'package:projects/presentation/views/project_detailed/project_overview.dart';

class ProjectDetailedView extends StatelessWidget {
  const ProjectDetailedView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProjectCellController controller = Get.arguments['controller'];

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: CustomAppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
              ),
              SizedBox(width: 10),
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
              )
            ],
          ),
          bottom: SizedBox(
            height: 25,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TabBar(
                  isScrollable: true,
                  indicatorColor: Theme.of(context).customColors().onSurface,
                  labelColor: Theme.of(context).customColors().onSurface,
                  unselectedLabelColor: Theme.of(context)
                      .customColors()
                      .onSurface
                      .withOpacity(0.6),
                  labelStyle: TextStyleHelper.subtitle2(),
                  tabs: [
                    Tab(text: 'Overview'),
                    Tab(text: 'Tasks'),
                    Tab(text: 'Milestones'),
                    Tab(text: 'Discussions'),
                    Tab(text: 'Documents'),
                    Tab(text: 'Team'),
                  ]),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ProjectOverview(controller: controller),
            for (var i = 0; i < 5; i++)
              ProjectOverview(
                controller: controller,
              )
          ],
        ),
      ),
    );
  }
}
