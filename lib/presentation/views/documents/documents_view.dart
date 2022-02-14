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

import 'dart:core';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/documents/base_documents_controller.dart';
import 'package:projects/domain/controllers/documents/documents_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/custom_searchbar.dart';
import 'package:projects/presentation/shared/widgets/search_button.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/wrappers/platform_icon_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_popup_menu_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_popup_menu_item.dart';
import 'package:projects/presentation/shared/wrappers/platform_text_button.dart';
import 'package:projects/presentation/views/documents/documents_shared.dart';
import 'package:projects/presentation/views/project_detailed/project_detailed_view.dart';
import 'package:projects/presentation/views/project_detailed/project_documents_view.dart';

class PortalDocumentsView extends StatelessWidget {
  const PortalDocumentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DocumentsController>(tag: 'DocumentsView');

    return DocumentsScreen(
      controller: controller,
    );
  }
}

class FolderContentView extends StatelessWidget {
  FolderContentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DocumentsController>();
    final folderName = Get.arguments['folderName'] as String?;
    final folderId = Get.arguments['folderId'] as int?;

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      controller.setupFolder(folderName: folderName!, folderId: folderId);
    });

    return DocumentsScreen(
      controller: controller,
      isCollapsed: true,
    );
  }
}

class DocumentsSearchView extends StatelessWidget {
  DocumentsSearchView({Key? key}) : super(key: key);

  final documentsController = Get.find<DocumentsController>();

  @override
  Widget build(BuildContext context) {
    final folderName = Get.arguments['folderName'] as String?;
    final folderId = Get.arguments['folderId'] as int?;

    documentsController.entityType = Get.arguments['entityType'] as String?;

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      documentsController.setupSearchMode(folderName: folderName, folderId: folderId);
    });

    return ProjectDocumentsScreen(
      controller: documentsController,
      appBar: StyledAppBar(
        title: CustomSearchBar(controller: documentsController),
        showBackButton: true,
        titleHeight: 50,
      ),
      //isCollapsed: true,
    );
  }
}

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({
    Key? key,
    required this.controller,
    this.isCollapsed = false,
  }) : super(key: key);

  final BaseDocumentsController controller;
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Get.theme.backgroundColor,
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          MainAppBar(
            isCollapsed: isCollapsed,
            materialTitle: Obx(
              () => Text(
                controller.documentsScreenName.value,
                style: TextStyleHelper.headline6(color: Get.theme.colors().onSurface),
              ),
            ),
            cupertinoTitle: Obx(
              () => Text(
                controller.documentsScreenName.value,
                style: TextStyle(color: Get.theme.colors().onSurface),
              ),
            ),
            actions: [
              SearchButton(controller: controller),
              DocumentsFilterButton(controller: controller),
              _MoreButtonWidget(controller: controller),
              const SizedBox(width: 7),
            ],
          ),
        ];
      },
      body: DocumentsContent(controller: controller),
    ));
  }
}

class _MoreButtonWidget extends StatelessWidget {
  const _MoreButtonWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final BaseDocumentsController controller;

  @override
  Widget build(BuildContext context) {
    return PlatformPopupMenuButton(
      padding: EdgeInsets.zero,
      icon: PlatformIconButton(
        padding: EdgeInsets.zero,
        cupertinoIcon: Icon(
          CupertinoIcons.ellipsis_circle,
          color: Get.theme.colors().primary,
        ),
        materialIcon: Icon(
          Icons.more_vert,
          color: Get.theme.colors().primary,
        ),
      ),
      onSelected: (String value) => _onSelected(value, controller, context),
      itemBuilder: (context) {
        return [
          PlatformPopupMenuItem(
            value: PopupMenuItemValue.sortDocuments,
            child: DocumentsSortButton(controller: controller),
          ),
        ];
      },
    );
  }
}

Future<void> _onSelected(
    String value, BaseDocumentsController controller, BuildContext context) async {
  switch (value) {
    case PopupMenuItemValue.sortDocuments:
      documentsSortButtonOnPressed(controller, context);
      break;
  }
}

class DocsBottom extends StatelessWidget {
  DocsBottom({Key? key, required this.controller}) : super(key: key);
  final BaseDocumentsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Obx(() {
            if (controller.itemList.isNotEmpty)
              return PlatformTextButton(
                padding: EdgeInsets.zero,
                onPressed: () => documentsSortButtonOnPressed(controller, context),
                child: DocumentsSortButton(
                  controller: controller,
                  color: Get.theme.colors().primary,
                ),
              );
            return const SizedBox();
          }),
          Obx(
            () => Text(
              tr('total', args: [controller.foldersCount.value.toString()]),
              style: TextStyleHelper.body2(
                color: Get.theme.colors().onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
