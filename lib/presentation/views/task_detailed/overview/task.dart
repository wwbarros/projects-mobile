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

part of 'tasks_overview_screen.dart';

class Task extends StatelessWidget {
  final TaskItemController taskController;

  const Task({Key key, @required this.taskController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(56, 20, 16, 16),
      child: Obx(
        () {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TASK', style: TextStyleHelper.overline),
              Text(taskController.task.value.title,
                  style: TextStyleHelper.headline6(
                      color: Theme.of(context).customColors().onSurface)),
              const SizedBox(height: 22),
              OutlinedButton(
                onPressed: () => showsStatusesBS(
                    context: context, taskItemController: taskController),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((_) {
                    return const Color(0xff81C4FF).withOpacity(0.1);
                  }),
                  side: MaterialStateProperty.resolveWith((_) {
                    return const BorderSide(
                        color: Color(0xff0C76D5), width: 1.5);
                  }),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(taskController.status.value.title,
                            style: TextStyleHelper.subtitle2()),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down_sharp)
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
