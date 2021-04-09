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

import 'package:get/get.dart';
import 'package:projects/data/api/tasks_api.dart';
import 'package:projects/data/models/from_api/task.dart';
import 'package:projects/domain/controllers/tasks/sort_controller.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class TaskService {
  final TaskApi _api = locator<TaskApi>();

  var portalTask = PortalTask().obs;

  Future getTaskByID({int id}) async {
    var task = await _api.getTaskByID(id: id);

    var success = task.response != null;

    if (success) {
      return task.response;
    } else {
      ErrorDialog.show(task.error);
      return null;
    }
  }

  Future getTasks({params = ''}) async {
    var tasks = await _api.getTasks(params: params);

    var success = tasks.response != null;

    if (success) {
      return tasks.response;
    } else {
      ErrorDialog.show(tasks.error);
      return null;
    }
  }

  Future getFilteredAndSortedTasks({String filters, String sort}) async {
    // Вся проблема в том, что не получается использовать фильтры и сортировку
    // в своих контроллерах и в них совершать обновления после новых фильтров.
    // Контроллеры сортировки и фильтров должны ссылаться на глобальный
    // контроллер тасков, чтобы вызвать getTasks. Но проблема в том, что в самом
    // TasksController также нужно использовать SortC. FiltersC., чтобы, например,
    // не потерять текущие настройки при обновлении или при выборе сортировки без
    // фильтров и наоборот. В итоге получится, что SortC ищет глобальный TasksC.,
    // а TasksC ищет одновременно SortC => ошибка Stack overflow (я так понял, ошибка)
    // из-за этого. Моим решением было сохранять все в TasksService, потому что
    // если его вызвать через locator, все норм. Надеюсь, понятно.

    // if you only want to filter, without sorting
    if (filters == null) {
      final _filterController = Get.find<TaskFilterController>();
      filters = _filterController.acceptedFilters.value;
    }
    if (sort == null) {
      final _sortController = Get.find<TasksSortController>();
      sort = _sortController.sort;
    }

    var params = filters + sort;
    var tasks = await _api.getTasks(params: params);

    var success = tasks.response != null;

    if (success) {
      return tasks.response;
    } else {
      ErrorDialog.show(tasks.error);
      return null;
    }
  }

  Future getStatuses() async {
    var statuses = await _api.getStatuses();

    var success = statuses.response != null;

    if (success) {
      return statuses.response;
    } else {
      ErrorDialog.show(statuses.error);
      return null;
    }
  }
}
