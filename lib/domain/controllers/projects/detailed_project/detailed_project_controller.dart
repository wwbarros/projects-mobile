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

import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:event_hub/event_hub.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/project_status.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/data/services/milestone_service.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/base_project_editor_controller.dart';
import 'package:projects/domain/controllers/project_team_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/domain/controllers/projects/project_status_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/projects_view/new_project/team_members_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectDetailsController extends BaseProjectEditorController {
  final _projectService = locator<ProjectService>();
  final _docApi = locator<FilesService>();

  RefreshController refreshController = RefreshController();
  var loaded = true.obs;

  final statuses = [].obs;

  var projectTitleText = ''.obs;

  var managerText = ''.obs;
  var teamMembers = [].obs;
  var teamMembersCount = 0.obs;

  var creationDateText = ''.obs;

  var statusText = ''.obs;
  var tasksCount = 0.obs;
  var docsCount = (-1).obs;

  var milestoneCount = (-1).obs;
  var currentTab = -1.obs;

  bool markedToDelete = false;

  final _projectDetailed = ProjectDetailed().obs;
  ProjectDetailed get projectData => _projectDetailed.value;

  StreamSubscription _refreshProjectsSubscription;
  StreamSubscription _refreshDetailsSubscription;

  final _userController = Get.find<UserController>();

  ProjectDetailsController() {
    _userController.getUserInfo().whenComplete(() => {
          selfUserItem =
              PortalUserItemController(portalUser: _userController.user),
        });

    _refreshProjectsSubscription = locator<EventHub>().on(
      'needToRefreshProjects',
      (dynamic data) {
        if (markedToDelete) {
          _refreshProjectsSubscription.cancel();
          return;
        }

        if (data != _projectDetailed.value.id) return;

        refreshData();
      },
    );

    _refreshDetailsSubscription = locator<EventHub>().on(
      'needToRefreshDetails',
      (dynamic data) {
        if (markedToDelete) {
          _refreshDetailsSubscription.cancel();
          return;
        }

        if (data != _projectDetailed.value.id) return;

        refreshProjectDetails();
      },
    );
  }

  @override
  void onClose() {
    _refreshProjectsSubscription.cancel();
    _refreshDetailsSubscription.cancel();
    super.onClose();
  }

  String decodeImageString(String image) {
    return utf8.decode(base64.decode(image));
  }

  Future<bool> refreshProjectDetails() async {
    var ret = await _projectService.getProjectById(
        projectId: _projectDetailed.value.id);

    if (ret != null) _projectDetailed.value = ret;
    await fillProjectInfo();
    if (ret?.tags != null) {
      tags.addAll(ret.tags);
      tagsText.value = ret.tags.join(', ');
    }

    tasksCount.value = _projectDetailed.value.taskCountTotal;

    final formatter = DateFormat.yMMMMd(Get.locale.languageCode);
    creationDateText.value =
        formatter.format(DateTime.parse(_projectDetailed.value.created));

    return Future.value(true);
  }

  Future<void> setup(projectDetailed) async {
    _projectDetailed.value = projectDetailed;

    await refreshProjectDetails();

    await _docApi
        .getFilesByParams(folderId: _projectDetailed.value.projectFolder)
        .then(
      (value) {
        if (value != null) docsCount.value = value.files.length;
      },
    );

    await locator<MilestoneService>()
        .milestonesByFilter(projectId: _projectDetailed.value.id.toString())
        .then((value) {
      if (value != null) milestoneCount.value = value.length;
    });
  }

  Future<void> fillProjectInfo() async {
    teamMembersCount.value = _projectDetailed.value.participantCount;

    var tream = Get.find<ProjectTeamController>()
      ..setup(projectDetailed: _projectDetailed.value);
    // ignore: unawaited_futures
    tream.getTeam().then((value) => {
          teamMembers.clear(),
          teamMembers.addAll(tream.usersList),
          teamMembers.removeWhere((element) =>
              element.portalUser.id == _projectDetailed.value.responsible.id),
        });

    statusText.value = tr('projectStatus',
        args: [ProjectStatus.toName(_projectDetailed.value.status)]);

    projectTitleText.value = _projectDetailed.value.title;
    descriptionText.value = _projectDetailed.value.description;
    managerText.value = _projectDetailed.value.responsible.displayName;

    milestoneCount.value = _projectDetailed.value.milestoneCount;
  }

  Future<void> refreshData() async {
    loaded.value = false;

    await setup(_projectDetailed.value);

    loaded.value = true;
  }

  Future manageTeamMembers() async {
    selectedProjectManager.value = projectData.responsible;

    selectedTeamMembers.clear();

    for (var user in teamMembers) {
      selectedTeamMembers.add(user);
    }
    Get.find<NavigationController>()
        .to(const TeamMembersSelectionView(), arguments: {'controller': this});
  }

  Future<void> copyLink() async {}

  Future deleteProject() async {
    markedToDelete = true;
    return await _projectService.deleteProject(
        projectId: _projectDetailed.value.id);
  }

  Future<bool> updateStatus({int newStatusId}) async =>
      Get.find<ProjectStatusesController>().updateStatus(
          newStatusId: newStatusId, projectData: _projectDetailed.value);

  Future followProject() async {
    await _projectService.followProject(projectId: _projectDetailed.value.id);
    await refreshData();
  }

  @override
  Future<void> confirmTeamMembers() async {
    Get.find<UsersDataSource>().loaded.value = false;
    var users = <String>[];

    for (var user in selectedTeamMembers) {
      users.add(user.id);
    }

    await _projectService.addToProjectTeam(projectData.id.toString(), users);
    await refreshData();
    Get.find<UsersDataSource>().loaded.value = true;

    Get.back();
  }
}
