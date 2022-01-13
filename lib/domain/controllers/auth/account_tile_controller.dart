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

import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:event_hub/event_hub.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/account_data.dart';
import 'package:projects/data/services/download_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/domain/controllers/auth/account_manager_controller.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';

class AccountTileController extends GetxController {
  final _downloadService = locator<DownloadService>();

  RxString userTitle = ''.obs;

  AccountTileController({this.accountData}) {
    if (accountData != null) setupUser();
  }

  final AccountData? accountData;

  String? get name => accountData!.name;
  String? get portal => accountData!.portal;

  Rx<Uint8List> avatarData = Uint8List.fromList([]).obs;

  Rx<Widget> avatar =
      // ignore: unnecessary_cast
      (AppIcon(width: 40, height: 40, icon: SvgIcons.avatar, color: Get.theme.colors().onSurface)
              as Widget)
          .obs;

  String? get displayName => accountData!.name;

  Future<void> loadAvatar() async {
    try {
      final avatarBytes = await _downloadService.downloadImage(accountData!.avatarUrl);
      if (avatarBytes == null) return;

      avatarData.value = avatarBytes;
      // ignore: unnecessary_cast
      avatar.value = Image.memory(avatarData.value) as Widget;
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
  }

  void setupUser() {
    if (accountData?.portal != null) {
      userTitle.value = accountData!.portal;
    }
    loadAvatar();
  }

  Future<void> loginToSavedAccount() async {
    Get.back();

    await locator<SecureStorage>()
        .putString('portalName', '${accountData!.scheme}${accountData!.portal}');
    await Get.find<LoginController>()
        .saveLoginData(token: accountData!.token, expires: accountData!.expires);

    locator<EventHub>().fire('loginSuccess');
  }

  Future<void> onTap() async => loginToSavedAccount();

  Future<void> deleteAccount() async {
    await Get.dialog(
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: StyledAlertDialog(
          titleText: tr('removeAccountTitle'),
          contentText: tr('removeAccountText'),
          acceptText: tr('removeAccount').toUpperCase(),
          cancelText: tr('cancel').toUpperCase(),
          onAcceptTap: () async => {
            await Get.find<AccountManagerController>().deleteAccounts(
                accountId: accountData!.id, accountData: jsonEncode(accountData!.toJson())),
            Get.back(),
          },
          onCancelTap: Get.back,
        ),
      ),
    );
  }
}