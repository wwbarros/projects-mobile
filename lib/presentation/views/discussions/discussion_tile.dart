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
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/custom_network_image.dart';

class DiscussionTile extends StatelessWidget {
  final Discussion discussion;
  final Function() onTap;
  const DiscussionTile({
    Key key,
    @required this.discussion,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            _Image(
              image: discussion.createdBy.avatar ??
                  discussion.createdBy.avatarMedium ??
                  discussion.createdBy.avatarSmall,
            ),
            const SizedBox(width: 16),
            _DiscussionInfo(discussion: discussion),
            const SizedBox(width: 11.33),
            _CommentsCount(commentsCount: discussion.commentsCount),
          ],
        ),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  final String image;
  const _Image({
    Key key,
    @required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: CustomNetworkImage(
          image: image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _DiscussionInfo extends StatelessWidget {
  final Discussion discussion;
  const _DiscussionInfo({
    Key key,
    @required this.discussion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            discussion.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyleHelper.projectTitle,
          ),
          RichText(
            text: TextSpan(
              style: TextStyleHelper.caption(
                  color: Theme.of(context)
                      .customColors()
                      .onSurface
                      .withOpacity(0.6)),
              children: [
                if (discussion.status == 1)
                  TextSpan(
                      text: 'Archived • ',
                      style: TextStyleHelper.status(
                          color: Theme.of(context).customColors().onSurface)),
                TextSpan(text: formatedDate(discussion.created)),
                const TextSpan(text: ' • '),
                TextSpan(text: discussion.createdBy.displayName)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentsCount extends StatelessWidget {
  final int commentsCount;
  const _CommentsCount({
    Key key,
    @required this.commentsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppIcon(
            icon: SvgIcons.comments,
            color:
                Theme.of(context).customColors().onBackground.withOpacity(0.6)),
        const SizedBox(width: 5.33),
        Text(commentsCount.toString(),
            style: TextStyleHelper.body2(
                color: Theme.of(context)
                    .customColors()
                    .onBackground
                    .withOpacity(0.6))),
      ],
    );
  }
}