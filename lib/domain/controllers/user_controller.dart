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

import 'package:projects/data/models/from_api/security_info.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:synchronized/synchronized.dart';

import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/internal/locator.dart';

class UserController extends GetxController {
  final _api = locator<AuthService>();
  var lock = Lock();

  PortalUser user;
  SecrityInfo securityInfo;
  var loaded = false.obs;

  Future<bool> getUserInfo() async {
    var ret = await lock.synchronized(() async {
      var data = await _api.getSelfInfo();
      if (data.response == null) return Future.value(false);
      user = data.response;
      loaded.value = securityInfo != null;
    });
    return Future.value(ret);
  }

  Future getSecurityInfo() async {
    var ret = await lock.synchronized(() async {
      securityInfo ??= await locator<ProjectService>().getProjectSecurityinfo();
      loaded.value = user != null;
      return Future.value(loaded.value);
    });
    return Future.value(ret);
  }

  Future<String> getUserId() async {
    if (user == null || user.id == null) {
      if (!await getUserInfo()) return null;
    }
    return user.id;
  }

  void clear() {
    user = null;
    securityInfo = null;
    loaded.value = false;
  }
}
