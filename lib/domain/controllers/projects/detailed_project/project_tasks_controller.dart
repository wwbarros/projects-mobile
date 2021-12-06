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

import 'package:event_hub/event_hub.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_tasks_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/services/task/task_service.dart';

class ProjectTasksController extends GetxController {
  final _api = locator<TaskService>();

  final paginationController =
      Get.put(PaginationController(), tag: 'ProjectTasksController');

  final _sortController =
      Get.put(TasksSortController(), tag: 'ProjectTasksController');

  final _filterController = Get.find<ProjectTaskFilterController>();

  ProjectDetailed _projectDetailed;

  ProjectTaskFilterController get filterController => _filterController;
  TasksSortController get sortController => _sortController;

  RxBool loaded = false.obs;

  var hasFilters = false.obs;

  int _projectId;

  var fabIsVisible = false.obs;

  ProjectTasksController() {
    _sortController.updateSortDelegate = () async => await loadTasks();
    _filterController.applyFiltersDelegate = () async => loadTasks();
    paginationController.loadDelegate = () async => await _getTasks();
    paginationController.refreshDelegate = () async => await refreshData();
    paginationController.pullDownEnabled = true;
  }

  RxList get itemList => paginationController.data;

  Future<void> refreshData() async {
    loaded.value = false;

    //await _getTasks(needToClear: true);
    locator<EventHub>().fire('needToRefreshDetails', _projectDetailed.id);

    loaded.value = true;
  }

  Future loadTasks() async {
    loaded.value = false;

    paginationController.startIndex = 0;
    await _getTasks(needToClear: true);

    loaded.value = true;
  }

  Future<bool> _getTasks({needToClear = false}) async {
    var result = await _api.getTasksByParams(
        startIndex: paginationController.startIndex,
        sortBy: _sortController.currentSortfilter,
        sortOrder: _sortController.currentSortOrder,
        responsibleFilter: _filterController.responsibleFilter,
        creatorFilter: _filterController.creatorFilter,
        projectFilter: _filterController.projectFilter,
        milestoneFilter: _filterController.milestoneFilter,
        deadlineFilter: _filterController.deadlineFilter,
        projectId: _projectId.toString());

    if (result == null) return Future.value(false);

    paginationController.total.value = result.total;
    if (needToClear) paginationController.data.clear();
    paginationController.data.addAll(result.response);

    return Future.value(true);
  }

  Future<void> setup(ProjectDetailed projectDetailed) async {
    loaded.value = false;
    _projectDetailed = projectDetailed;
    _projectId = projectDetailed.id;
    _filterController.projectId = _projectId.toString();
    fabIsVisible.value = _canCreate();

    await loadTasks();
  }

  bool _canCreate() => _projectDetailed.security['canCreateTask'];
}
