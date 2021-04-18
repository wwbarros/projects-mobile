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

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/services/task_item_service.dart';
import 'package:projects/domain/controllers/tasks/task_status_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TaskItemController extends GetxController {
  final _api = locator<TaskItemService>();

  var task = PortalTask().obs;
  var status = Status().obs;

  var loaded = true.obs;
  var refreshController = RefreshController();

  RxString statusImageString = ''.obs;

  TaskItemController(PortalTask task) {
    this.task.value = task;
    initTaskStatus(task);
  }

  void initTaskStatus(PortalTask task) {
    var statusesController = Get.find<TaskStatusesController>();

    status.value = statusesController.getTaskStatus(task);
    statusImageString.value =
        statusesController.decodeImageString(status.value.image);
  }

  Future reloadTask() async {
    loaded.value = false;
    var t = await _api.getTaskByID(id: task.value.id);
    task.value = t;
    loaded.value = true;
  }

  Future updateTaskStatus({int id, int newStatusId, int newStatusType}) async {
    loaded.value = false;
    var t = await _api.updateTaskStatus(
        taskId: id, newStatusId: newStatusId, newStatusType: newStatusType);
    var newTask = PortalTask.fromJson(t);
    task.value = newTask;
    initTaskStatus(newTask);
    loaded.value = true;
  }

  Future deleteTask({@required int taskId}) async {
    var r = await _api.deleteTask(taskId: taskId);
    if (r != null) return 'ok';
  }

  Future subscribeToTask({@required int taskId}) async {
    var r = await _api.subscribeToTask(taskId: taskId);
    if (r != null) return 'ok';
  }

  void handleVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 1) {
      update();
    }
  }
}
