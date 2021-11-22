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

import 'package:projects/data/models/from_api/contact.dart';
import 'package:projects/data/models/from_api/portal_group.dart';

class PortalUser {
  String? id;
  String? userName;
  bool? isVisitor;
  String? firstName;
  String? lastName;
  String? email;
  String? birthday;
  String? sex;
  int? status;
  int? activationStatus;
  String? terminated;
  String? department;
  String? workFrom;
  String? displayName;
  String? mobilePhone;
  String? title;
  List<Contact>? contacts;
  List<PortalGroup>? groups;
  String? avatarMedium;
  String? avatar;
  bool? isAdmin;
  bool? isLDAP;
  bool? isOwner;
  bool? isSSO;
  String? avatarSmall;
  String? profileUrl;
  List<String>? listAdminModules;

  PortalUser({
    this.id,
    this.userName,
    this.isVisitor,
    this.firstName,
    this.lastName,
    this.email,
    this.birthday,
    this.sex,
    this.status,
    this.activationStatus,
    this.terminated,
    this.department,
    this.workFrom,
    this.displayName,
    this.mobilePhone,
    this.title,
    this.contacts,
    this.groups,
    this.avatarMedium,
    this.avatar,
    this.isAdmin,
    this.isLDAP,
    this.isOwner,
    this.isSSO,
    this.avatarSmall,
    this.profileUrl,
    this.listAdminModules,
  });

  PortalUser.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userName = json['userName'];
    isVisitor = json['isVisitor'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    birthday = json['birthday'];
    sex = json['sex'];
    status = json['status'];
    activationStatus = json['activationStatus'];
    terminated = json['terminated'];
    department = json['department'];
    workFrom = json['workFrom'];
    displayName = json['displayName'];
    mobilePhone = json['mobilePhone'];
    title = json['title'];
    if (json['contacts'] != null) {
      contacts = <Contact>[];
      json['contacts'].forEach((v) {
        contacts!.add(Contact.fromJson(v));
      });
    }
    if (json['groups'] != null) {
      groups = <PortalGroup>[];
      json['groups'].forEach((v) {
        groups!.add(PortalGroup.fromJson(v));
      });
    }
    avatarMedium = json['avatarMedium'];
    avatar = json['avatar'];
    isAdmin = json['isAdmin'];
    isLDAP = json['isLDAP'];
    isOwner = json['isOwner'];
    isSSO = json['isSSO'];
    avatarSmall = json['avatarSmall'];
    profileUrl = json['profileUrl'];
    if (json['listAdminModules'] != null) {
      listAdminModules = <String>[];
      json['listAdminModules'].forEach((v) {
        listAdminModules!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userName'] = userName;
    data['isVisitor'] = isVisitor;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['birthday'] = birthday;
    data['sex'] = sex;
    data['status'] = status;
    data['activationStatus'] = activationStatus;
    data['terminated'] = terminated;
    data['department'] = department;
    data['workFrom'] = workFrom;
    data['displayName'] = displayName;
    data['mobilePhone'] = mobilePhone;
    data['title'] = title;
    if (contacts != null) {
      data['contacts'] = contacts!.map((v) => v.toJson()).toList();
    }
    if (groups != null) {
      data['groups'] = groups!.map((v) => v.toJson()).toList();
    }
    data['avatarMedium'] = avatarMedium;
    data['avatar'] = avatar;
    data['isAdmin'] = isAdmin;
    data['isLDAP'] = isLDAP;
    data['isOwner'] = isOwner;
    data['isSSO'] = isSSO;
    data['avatarSmall'] = avatarSmall;
    data['profileUrl'] = profileUrl;
    if (listAdminModules != null) {
      // data['contacts'] = listAdminModules.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
