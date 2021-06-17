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

import 'package:flutter/services.dart';
import 'package:projects/domain/controllers/documents/documents_move_or_copy_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/widgets/styled_snackbar.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/documents/documents_view.dart';

class DocumentsMoveOrCopyView extends StatelessWidget {
  DocumentsMoveOrCopyView({Key key}) : super(key: key);

  final controller = Get.find<DocumentsMoveOrCopyController>();

  @override
  Widget build(BuildContext context) {
    final target = Get.arguments['target'];
    final int initialFolderId = Get.arguments['initialFolderId'];
    final refreshCalback = Get.arguments['refreshCalback'];
    final String mode = Get.arguments['mode'];

    controller.initialSetup();
    if (mode == 'moveFolder') {
      controller.setupMovingFolder(target, initialFolderId);
    }
    if (mode == 'copyFolder') {
      controller.setupCopyingFolder(target, initialFolderId);
    }
    if (mode == 'moveFile') {
      controller.setupMovingFile(target, initialFolderId);
    }
    if (mode == 'copyFile') {
      controller.setupCopyingFile(target, initialFolderId);
    }
    controller.foldersCount = 1;
    controller.refreshCalback = refreshCalback;
    controller.mode = mode;

    return MoveDocumentsScreen(
      controller: controller,
      appBar: StyledAppBar(
        title: _Title(controller: controller),
        bottom: DocsBottom(controller: controller),
        // title: Container(
        //   padding: const EdgeInsets.symmetric(vertical: 16),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     children: <Widget>[
        //       Expanded(
        //         child: Obx(
        //           () => Text(
        //             controller.screenName.value,
        //             style: TextStyleHelper.headerStyle,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        showBackButton: true,
        titleHeight: 50,
      ),
    );
  }
}

class _FolderContentView extends StatelessWidget {
  _FolderContentView({Key key}) : super(key: key);

  final controller = Get.find<DocumentsMoveOrCopyController>();

  @override
  Widget build(BuildContext context) {
    final Folder currentFolder = Get.arguments['currentFolder'];
    final target = Get.arguments['target'];
    final int initialFolderId = Get.arguments['initialFolderId'];
    final int foldersCount = Get.arguments['foldersCount'];
    final refreshCalback = Get.arguments['refreshCalback'];
    final String mode = Get.arguments['mode'];

    controller.setupFolder(
        folderName: currentFolder.title, folder: currentFolder);

    if (mode == 'moveFolder') {
      controller.setupMovingFolder(target, initialFolderId);
    }
    if (mode == 'copyFolder') {
      controller.setupCopyingFolder(target, initialFolderId);
    }
    if (mode == 'moveFile') {
      controller.setupMovingFile(target, initialFolderId);
    }
    if (mode == 'copyFile') {
      controller.setupCopyingFile(target, initialFolderId);
    }

    controller.foldersCount = foldersCount + 1;
    controller.refreshCalback = refreshCalback;
    controller.mode = mode;

    return MoveDocumentsScreen(
      controller: controller,
      appBar: StyledAppBar(
        title: _Title(controller: controller),
        bottom: DocsBottom(controller: controller),
        showBackButton: true,
        titleHeight: 50,
        bottomHeight: 50,
      ),
    );
  }
}

class DocumentsMoveSearchView extends StatelessWidget {
  DocumentsMoveSearchView({Key key}) : super(key: key);

  final controller = Get.find<DocumentsMoveOrCopyController>();

  @override
  Widget build(BuildContext context) {
    final Folder currentFolder = Get.arguments['currentFolder'];
    final target = Get.arguments['target'];
    final int initialFolderId = Get.arguments['initialFolderId'];
    final int foldersCount = Get.arguments['foldersCount'];
    final refreshCalback = Get.arguments['refreshCalback'];
    final String folderName = Get.arguments['folderName'];
    final String mode = Get.arguments['mode'];

    controller.setupSearchMode(folderName: folderName, folder: currentFolder);

    if (mode == 'moveFolder') {
      controller.setupMovingFolder(target, initialFolderId);
    }
    if (mode == 'copyFolder') {
      controller.setupCopyingFolder(target, initialFolderId);
    }
    if (mode == 'moveFile') {
      controller.setupMovingFile(target, initialFolderId);
    }
    if (mode == 'copyFile') {
      controller.setupCopyingFile(target, initialFolderId);
    }

    controller.foldersCount = foldersCount + 1;
    controller.refreshCalback = refreshCalback;
    controller.mode = mode;

    return _DocumentsScreen(
      controller: controller,
      appBar: StyledAppBar(
        title: _SearchHeader(controller: controller),
        showBackButton: true,
        titleHeight: 50,
      ),
    );
  }
}

class _DocumentsScreen extends StatelessWidget {
  const _DocumentsScreen({
    Key key,
    @required this.controller,
    this.appBar,
  }) : super(key: key);
  final StyledAppBar appBar;
  final DocumentsMoveOrCopyController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBar,
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (controller.nothingFound.isTrue) const NothingFound(),
            if (controller.loaded.isFalse) const ListLoadingSkeleton(),
            if (controller.loaded.isTrue)
              Expanded(
                child: PaginationListView(
                  paginationController: controller.paginationController,
                  child: ListView.separated(
                    itemCount: controller.paginationController.data.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      var element = controller.paginationController.data[index];
                      return _MoveFolderContent(
                        element: element,
                        controller: controller,
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final DocumentsMoveOrCopyController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Container(
        child: Material(
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  controller: controller.searchInputController,
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Enter your query'),
                  onSubmitted: (value) {
                    controller.newSearch(value);
                  },
                ),
              ),
              InkResponse(
                onTap: () {
                  controller.clearSearch();
                },
                child: const Icon(Icons.close, color: Colors.blue),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key key, @required this.controller}) : super(key: key);

  final DocumentsMoveOrCopyController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Obx(
              () => Text(
                controller.screenName.value,
                style: TextStyleHelper.headerStyle,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkResponse(
                onTap: () {
                  var target;
                  if (controller.mode == 'moveFolder')
                    target = controller.folderToMove;
                  if (controller.mode == 'copyFolder')
                    target = controller.folderToCopy;
                  if (controller.mode == 'moveFile')
                    target = controller.fileToMove;
                  if (controller.mode == 'copyFile')
                    target = controller.fileToCopy;

                  Get.to(DocumentsMoveSearchView(),
                      preventDuplicates: false,
                      arguments: {
                        'mode': controller.mode,
                        'folderName': controller.screenName.value,
                        'target': target,
                        'currentFolder': controller.currentFolder,
                        'initialFolderId': controller.initialFolderId,
                        'foldersCount': controller.foldersCount,
                        'refreshCalback': controller.refreshCalback,
                      });
                },
                child: AppIcon(
                  width: 24,
                  height: 24,
                  icon: SvgIcons.search,
                  color: Theme.of(context).customColors().primary,
                ),
              ),
              const SizedBox(width: 24),
              InkResponse(
                onTap: () async => Get.toNamed('DocumentsFilterScreen',
                    preventDuplicates: false,
                    arguments: {
                      'filterController': controller.filterController
                    }),
                child: FiltersButton(controler: controller),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MoveFolderContent extends StatelessWidget {
  const _MoveFolderContent({
    Key key,
    @required this.element,
    @required this.controller,
  }) : super(key: key);

  final Folder element;
  final DocumentsMoveOrCopyController controller;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        var target;
        if (controller.mode == 'moveFolder') target = controller.folderToMove;
        if (controller.mode == 'copyFolder') target = controller.folderToCopy;
        if (controller.mode == 'moveFile') target = controller.fileToMove;
        if (controller.mode == 'copyFile') target = controller.fileToCopy;
        Get.to(_FolderContentView(), preventDuplicates: false, arguments: {
          'mode': controller.mode,
          'target': target,
          'currentFolder': element,
          'initialFolderId': controller.initialFolderId,
          'foldersCount': controller.foldersCount,
          'refreshCalback': controller.refreshCalback,
        });
      },
      child: Container(
        child: Row(
          children: [
            SizedBox(
              width: 72,
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color(0xffD8D8D8),
                    ),
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: AppIcon(
                      width: 20,
                      height: 20,
                      icon: SvgIcons.folder,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(element.title),
                  Text(
                      '${formatedDate(element.updated)} • documents:${element.filesCount} • subfolders:${element.foldersCount}',
                      style: TextStyleHelper.caption(
                          color: Theme.of(context)
                              .customColors()
                              .onSurface
                              .withOpacity(0.6))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoveDocumentsScreen extends StatelessWidget {
  const MoveDocumentsScreen({
    Key key,
    @required this.controller,
    this.appBar,
  }) : super(key: key);
  final StyledAppBar appBar;
  final DocumentsMoveOrCopyController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBar,
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (controller.nothingFound.isTrue) const NothingFound(),
            if (controller.loaded.isFalse) const ListLoadingSkeleton(),
            if (controller.loaded.isTrue)
              Expanded(
                child: PaginationListView(
                  paginationController: controller.paginationController,
                  child: ListView.separated(
                    itemCount: controller.paginationController.data.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      var element = controller.paginationController.data[index];
                      return element is Folder
                          ? _MoveFolderContent(
                              element: element,
                              controller: controller,
                            )
                          : const SizedBox();
                    },
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () => _cancel(controller),
                  child: Text('cancel'.toUpperCase(),
                      style: TextStyleHelper.button()),
                ),
                if (controller.mode == 'moveFolder')
                  TextButton(
                    onPressed: () => _moveFolder(controller, context),
                    child: Text('move folder here'.toUpperCase(),
                        style: TextStyleHelper.button()),
                  ),
                if (controller.mode == 'copyFolder')
                  TextButton(
                    onPressed: () => _copyFolder(controller, context),
                    child: Text('copy folder here'.toUpperCase(),
                        style: TextStyleHelper.button()),
                  ),
                if (controller.mode == 'moveFile')
                  TextButton(
                    onPressed: () => _moveFile(controller, context),
                    child: Text('move file here'.toUpperCase(),
                        style: TextStyleHelper.button()),
                  ),
                if (controller.mode == 'copyFile')
                  TextButton(
                    onPressed: () => _copyFile(controller, context),
                    child: Text('copy file here'.toUpperCase(),
                        style: TextStyleHelper.button()),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future _moveFolder(
  DocumentsMoveOrCopyController controller,
  BuildContext context,
) async {
  var success = await controller.moveFolder();

  if (success) {
    Get.close(controller.foldersCount);
    if (controller.refreshCalback != null) controller.refreshCalback();

    ScaffoldMessenger.of(context).showSnackBar(
        styledSnackBar(context: context, text: 'Folder had been moved'));
  }
}

Future _copyFolder(
  DocumentsMoveOrCopyController controller,
  BuildContext context,
) async {
  var success = await controller.copyFolder();

  if (success) {
    Get.close(controller.foldersCount);
    if (controller.refreshCalback != null) controller.refreshCalback();

    ScaffoldMessenger.of(context).showSnackBar(
        styledSnackBar(context: context, text: 'Folder had been copied'));
  }
}

Future _moveFile(
  DocumentsMoveOrCopyController controller,
  BuildContext context,
) async {
  var success = await controller.moveFile();

  if (success) {
    Get.close(controller.foldersCount);
    if (controller.refreshCalback != null) controller.refreshCalback();

    ScaffoldMessenger.of(context).showSnackBar(
        styledSnackBar(context: context, text: 'File had been moved'));
  }
}

Future _copyFile(
  DocumentsMoveOrCopyController controller,
  BuildContext context,
) async {
  var success = await controller.copyFile();

  if (success) {
    Get.close(controller.foldersCount);
    if (controller.refreshCalback != null) controller.refreshCalback();

    ScaffoldMessenger.of(context).showSnackBar(
        styledSnackBar(context: context, text: 'File had been copied'));
  }
}

Future _cancel(DocumentsMoveOrCopyController controller) async {
  Get.close(controller.foldersCount);
  if (controller.refreshCalback != null) controller.refreshCalback();
}