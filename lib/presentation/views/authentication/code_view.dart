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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';

import 'package:projects/presentation/views/authentication/widgets/wide_button.dart';

class CodeView extends StatefulWidget {
  CodeView({Key key}) : super(key: key);

  @override
  _CodeViewState createState() => _CodeViewState();
}

class _CodeViewState extends State<CodeView> {
  var controller;

  var codeController;

  @override
  void initState() {
    controller = Get.find<LoginController>();
    codeController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Scaffold(
          appBar: StyledAppBar(),
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                color: Get.theme.backgroundColor,
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
                    AppIcon(
                      icon: PngIcons.code_light,
                      isPng: true,
                      height: 200,
                      width: 200,
                    ),
                    SizedBox(height: Get.height * 0.0347),
                    Text(tr('tfaTitle'),
                        textAlign: TextAlign.center,
                        style: TextStyleHelper.headline5(
                            color: Get.theme.colors().onSurface)),
                    SizedBox(height: Get.height * 0.0222),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        tr('tfaGAcodeDescription'),
                        textAlign: TextAlign.center,
                        style: TextStyleHelper.body2(
                            color:
                                Get.theme.colors().onSurface.withOpacity(0.6)),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.0333),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: TextField(
                        controller: codeController,
                        textAlign: TextAlign.center,
                        style: TextStyleHelper.subtitle1(),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.055),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: WideButton(
                        text: tr('confirm'),
                        onPressed: () async =>
                            await controller.sendCode(codeController.text),
                      ),
                    ),
                    // Center(
                    //   child: Container(
                    //     color: Get.theme.backgroundColor,
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(36.0),
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: <Widget>[
                    //           const SizedBox(height: 10.0),
                    // CodeForm()
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
