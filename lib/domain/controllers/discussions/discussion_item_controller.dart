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
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/services/discussion_item_service.dart';
import 'package:projects/domain/controllers/discussions/discussions_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_discussions_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/discussions/widgets/discussion_status_BS.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:visibility_detector/visibility_detector.dart';

class DiscussionItemController extends GetxController {
  final _api = locator<DiscussionItemService>();

  var discussion = Discussion().obs;
  var status = 0.obs;

  var loaded = true.obs;
  var refreshController = RefreshController();
  var selfId;

  RxString statusImageString = ''.obs;
  // to show overview screen without loading
  RxBool firstReload = true.obs;

  DiscussionItemController(Discussion discussion) {
    this.discussion.value = discussion;
    status.value = discussion.status;
  }

  @override
  void onInit() async {
    selfId = await Get.find<UserController>().getUserId();
    super.onInit();
  }

  bool get isSubscribed {
    for (var item in discussion.value.subscribers) {
      if (item.id == selfId) return true;
    }
    return false;
  }

  void onRefresh() async => await getDiscussionDetailed();

  Future<void> getDiscussionDetailed({bool showLoading = true}) async {
    if (showLoading) loaded.value = false;
    var result = await _api.getMessageDetailed(id: discussion.value.id);
    if (result != null) {
      try {
        discussion.value = result;
        status.value = result.status;
        // ignore: empty_catches
      } catch (e) {}
    }
    if (showLoading) loaded.value = true;
  }

  void tryChangingStatus(context) async {
    if (discussion.value.canEdit) {
      await showsDiscussionStatusesBS(context: context, controller: this);
    }
  }

  Future<void> updateMessageStatus(int newStatus) async {
    var newStatusStr = newStatus == 1 ? 'Archived' : 'Open';

    try {
      Discussion result = await _api.updateMessageStatus(
          id: discussion.value.id, newStatus: newStatusStr);
      if (result != null) {
        discussion.value.setStatus = result.status;
        status.value = result.status;
        Get.back();
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> subscribeToMessageAction() async {
    try {
      Discussion result =
          await _api.subscribeToMessage(id: discussion.value.id);
      if (result != null) {
        discussion.value.setSubscribers = result.subscribers;
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> deleteMessage() async {
    try {
      Discussion result = await _api.deleteMessage(id: discussion.value.id);
      if (result != null) {
        Get.back();
        await Get.find<DiscussionsController>().loadDiscussions();
        try {
          // ignore: unawaited_futures
          Get.find<ProjectDiscussionsController>().loadProjectDiscussions();
        } catch (e) {
          debugPrint(e);
        }
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  void handleVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 1) update();
  }
}
