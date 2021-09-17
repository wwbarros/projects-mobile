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
import 'package:event_hub/event_hub.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/documents/documents_controller.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/custom_tab.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/documents/entity_documents_view.dart';
import 'package:projects/presentation/views/task_detailed/comments/task_comments_view.dart';
import 'package:projects/presentation/views/task_detailed/overview/tasks_overview_screen.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/subtasks_view.dart';
import 'package:projects/presentation/views/task_editing_view/task_editing_view.dart';

part 'app_bar_menu.dart';

class TaskDetailedView extends StatefulWidget {
  TaskDetailedView({Key key}) : super(key: key);

  @override
  _TaskDetailedViewState createState() => _TaskDetailedViewState();
}

class _TaskDetailedViewState extends State<TaskDetailedView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  // ignore: prefer_final_fields
  var _activeIndex = 0.obs;
  TaskItemController controller;
  final documentsController = Get.find<DocumentsController>();

  @override
  void initState() {
    super.initState();
    controller = Get.arguments['controller'];
    controller.firstReload.value = true;
    controller.reloadTask();
    _tabController = TabController(vsync: this, length: 4);

    documentsController.entityType = 'task';
    documentsController.setupFolder(
        folderId: controller.task.value.id,
        folderName: controller.task.value.title);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController.addListener(() {
      if (_activeIndex.value == _tabController.index) return;

      _activeIndex.value = _tabController.index;
    });
    return Obx(
      () => Scaffold(
        appBar: StyledAppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => Get.find<NavigationController>()
                  .to(TaskEditingView(task: controller.task.value)),
            ),
            _AppBarMenu(controller: controller)
          ],
          bottom: SizedBox(
            height: 40,
            child: TabBar(
                isScrollable: true,
                controller: _tabController,
                indicatorColor: Get.theme.colors().primary,
                labelColor: Get.theme.colors().onSurface,
                unselectedLabelColor:
                    Get.theme.colors().onSurface.withOpacity(0.6),
                labelStyle: TextStyleHelper.subtitle2(),
                tabs: [
                  Tab(text: tr('overview')),
                  CustomTab(
                      title: tr('subtasks'),
                      currentTab: _activeIndex.value == 1,
                      count: controller.task.value?.subtasks?.length),
                  CustomTab(
                      title: tr('documents'),
                      currentTab: _activeIndex.value == 2,
                      count: controller.task.value?.files?.length),
                  CustomTab(
                      title: tr('comments'),
                      currentTab: _activeIndex.value == 3,
                      count: controller.getActualCommentCount)
                ]),
          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          TasksOverviewScreen(taskController: controller),
          SubtasksView(controller: controller),
          EntityDocumentsView(
            folderId: controller.task.value.id,
            folderName: controller.task.value.title,
            documentsController: documentsController,
          ),
          TaskCommentsView(controller: controller)
        ]),
      ),
    );
  }
}
