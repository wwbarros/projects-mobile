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
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/services/subtasks_service.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled_snackbar.dart';

class SubtaskController extends GetxController {
  final SubtasksService _api = locator<SubtasksService>();
  Rx<Subtask> subtask;

  final _userController = Get.find<UserController>();
  SubtaskController({Subtask subtask}) {
    this.subtask = subtask.obs;
  }

  void acceptSubtask(
    context, {
    @required int taskId,
    @required int subtaskId,
  }) async {
    await _userController.getUserInfo();
    var selfUser = _userController.user;
    var data = {'responsible': selfUser.id, 'title': subtask.value.title};

    var result = await _api.acceptSubtask(
        data: data, taskId: taskId, subtaskId: subtaskId);

    if (result != null) {
      subtask.value = result;
      ScaffoldMessenger.of(context).showSnackBar(styledSnackBar(
        context: context,
        text: 'Subtask has been accepted by you',
        buttonText: 'OK',
        buttonOnTap: ScaffoldMessenger.maybeOf(context).hideCurrentSnackBar,
      ));
    }
  }

  void copySubtask(
    context, {
    @required int taskId,
    @required int subtaskId,
  }) async {
    var result = await _api.copySubtask(taskId: taskId, subtaskId: subtaskId);
    if (result != null) {
      var taskItemController =
          Get.find<TaskItemController>(tag: taskId.toString());
      ScaffoldMessenger.of(context).showSnackBar(styledSnackBar(
        context: context,
        text: 'Subtask has been copied',
      ));
      await taskItemController.reloadTask();
    }
  }

  void deleteSubtask({
    @required int taskId,
    @required int subtaskId,
    bool closePage = false,
  }) async {
    var result = await _api.deleteSubtask(taskId: taskId, subtaskId: subtaskId);
    if (result != null) {
      var taskItemController =
          Get.find<TaskItemController>(tag: taskId.toString());
      await taskItemController.reloadTask();
      if (closePage) Get.back();
    }
  }

  void updateSubtaskStatus({
    @required context,
    @required int taskId,
    @required int subtaskId,
  }) async {
    if (subtask.value.canEdit) {
      var newStatus;

      if (subtask.value.status == 1)
        newStatus = 'closed';
      else
        newStatus = 'open';

      var data = {'status': newStatus};

      var result = await _api.updateSubtaskStatus(
          data: data, taskId: taskId, subtaskId: subtaskId);

      if (result != null) subtask.value = result;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(styledSnackBar(
        context: context,
        text: 'You do not have permission to edit this subtask',
      ));
    }
  }

  void deleteSubtaskResponsible({
    @required int taskId,
    @required int subtaskId,
  }) async {
    if (subtask.value.canEdit) {
      var data = {'title': subtask.value.title, 'responsible': null};

      var result = await _api.updateSubtask(
        data: data,
        taskId: taskId,
        subtaskId: subtaskId,
      );

      if (result != null) subtask.value = result;
    }
  }
}