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
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';

class DashboardController extends GetxController {
  var screenName = tr('dashboard').obs;
  TasksController _myTaskController;
  TasksController _upcomingTaskscontroller;

  ProjectsController _myProjectsController;
  ProjectsController _folowedProjectsController;
  ProjectsController _activeProjectsController;
  var scrollController = ScrollController();

  DashboardController() {
    setupMyTask();
    setupUpcomingTasks();

    setupMyProjects();
    setupMyFolowedProjects();
    setupActiveProjects();
  }

  TasksController get myTaskController => _myTaskController;
  TasksController get upcomingTaskscontroller => _upcomingTaskscontroller;

  ProjectsController get myProjectsController => _myProjectsController;
  ProjectsController get folowedProjectsController =>
      _folowedProjectsController;
  ProjectsController get activeProjectsController => _activeProjectsController;

  void setupMyTask() {
    final _filterController = Get.put(
      TaskFilterController(),
      tag: 'MyTasksContent',
    );

    _myTaskController = Get.put(
      TasksController(
        _filterController,
        Get.put(PaginationController(), tag: 'MyTasksContent'),
      ),
      tag: 'MyTasksContent',
    );
    _myTaskController.expandedCardView.value = true;
    _filterController
        .setupPreset('myTasks')
        .then((value) => _myTaskController.loadTasks());
  }

  void setupUpcomingTasks() {
    final _filterController = Get.put(
      TaskFilterController(),
      tag: 'UpcommingContent',
    );

    _upcomingTaskscontroller = Get.put(
      TasksController(
        _filterController,
        Get.put(PaginationController(), tag: 'UpcommingContent'),
      ),
      tag: 'UpcommingContent',
    );
    _filterController
        .setupPreset('upcomming')
        .then((value) => _upcomingTaskscontroller.loadTasks());
  }

  void setupMyProjects() {
    final _filterController = Get.put(
      ProjectsFilterController(),
      tag: 'myProjects',
    );

    _myProjectsController = Get.put(
      ProjectsController(
        _filterController,
        Get.put(PaginationController(), tag: 'myProjects'),
      ),
      tag: 'myProjects',
    );

    _filterController
        .setupPreset('myProjects')
        .then((value) => _myProjectsController.loadProjects());
  }

  void setupMyFolowedProjects() {
    final _filterController =
        Get.put(ProjectsFilterController(), tag: 'myFollowedProjects');

    _folowedProjectsController = Get.put(
        ProjectsController(
          _filterController,
          Get.put(PaginationController(), tag: 'myFollowedProjects'),
        ),
        tag: 'myFollowedProjects');
    _filterController
        .setupPreset('myFollowedProjects')
        .then((value) => _folowedProjectsController.loadProjects());
  }

  void setupActiveProjects() {
    final _filterController =
        Get.put(ProjectsFilterController(), tag: 'active');

    _activeProjectsController = Get.put(
        ProjectsController(
          _filterController,
          Get.put(PaginationController(), tag: 'active'),
        ),
        tag: 'active');
    _filterController
        .setupPreset('active')
        .then((value) => _activeProjectsController.loadProjects());
  }
}
