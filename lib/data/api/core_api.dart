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

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:projects/data/services/storage.dart';
import 'package:projects/internal/locator.dart';

class CoreApi {
  var client = http.Client();
  final _secureStorage = locator<SecureStorage>();
  String _portalName;

  Future<Map<String, String>> getHeaders() async {
    var token = await getToken();
    return <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': token
    };
  }

  var version = '2.0';

  String capabilitiesUrl(String portalName) {
    if (portalName.contains('http')) {
      _portalName = portalName;
    } else {
      _portalName = 'https://$portalName';
    }

    return '$_portalName/api/$version/capabilities';
  }

  Future<String> addTaskConmmentUrl({int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/comment';

  Future<String> allGroups() async =>
      '${await getPortalURI()}/api/$version/group';

  Future<String> addTaskUrl({projectId}) async =>
      '${await getPortalURI()}/api/$version/project/$projectId/task';

  Future<String> allProfiles() async =>
      '${await getPortalURI()}/api/$version/people';

  Future<String> authUrl() async =>
      '${await getPortalURI()}/api/$version/authentication.json';

  Future<String> copyTask({@required int copyFrom}) async =>
      '${await getPortalURI()}/api/2.0/project/task/$copyFrom/copy';

  Future<String> copySubtask({
    @required int taskId,
    @required int subtaskId,
  }) async =>
      '${await getPortalURI()}/api/2.0/project/task/$taskId/$subtaskId/copy';

  Future<String> createSubtaskUrl({@required int taskId}) async =>
      '${await getPortalURI()}/api/2.0/project/task/$taskId';

  Future<String> deleteTask({int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId';

  Future<String> deleteSubtask({
    @required int taskId,
    @required int subtaskId,
  }) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/$subtaskId';

  Future<String> getTaskFiles({int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/files';

  Future<String> getProjectFilesUrl({String projectId}) async =>
      '${await getPortalURI()}/api/$version/project/$projectId/files';

  Future<String> milestonesByFilter() async =>
      '${await getPortalURI()}/api/$version/project/milestone/filter?';

  Future<String> getTaskLink({@required taskId, @required projectId}) async =>
      '${await getPortalURI()}/Products/Projects/Tasks.aspx?prjID=$projectId&id=$taskId#';

  Future<String> tfaUrl(String code) async =>
      '${await getPortalURI()}/api/$version/authentication/$code';

  Future<String> projectsByParamsBaseUrl() async =>
      '${await getPortalURI()}/api/$version/project/filter?';

  Future<String> tasksByParamsrUrl() async =>
      '${await getPortalURI()}/api/$version/project/task/filter?';

  Future<String> taskByIdUrl(int id) async =>
      '${await getPortalURI()}/api/$version/project/task/$id';

  Future<String> taskComments({int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/comment';

  Future<String> projectsUrl() async =>
      '${await getPortalURI()}/api/$version/project';

  Future<String> projectByIdUrl(int projectId) async =>
      '${await getPortalURI()}/api/$version/project/$projectId';

  Future<String> projectTags() async =>
      '${await getPortalURI()}/api/$version/project/tag';

  Future<String> selfInfoUrl() async =>
      '${await getPortalURI()}/api/$version/people/@self';

  Future<String> statusesUrl() async =>
      '${await getPortalURI()}/api/$version/project/status';

  Future<String> subscribeTask({int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/subscribe';

  Future<String> updateSubtask({
    @required int taskId,
    @required int subtaskId,
  }) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/$subtaskId';

  Future<String> updateSubtaskStatus({
    @required int taskId,
    @required int subtaskId,
  }) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/$subtaskId/status';

  Future<String> updateTask({@required int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId';

  Future<String> updateTaskStatusUrl({int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/status';

  Future<String> createProjectUrl() async =>
      '${await getPortalURI()}/api/$version/project/withSecurity';
  Future<String> projectTeamUrl(String projectID) async =>
      '${await getPortalURI()}/api/$version/project/$projectID/team';

  Future<String> createMilestoneUrl(String projectID) async =>
      '${await getPortalURI()}/api/$version/project/$projectID/milestone';
  //  api/2.0/project/1234/milestone

  Future<http.Response> getRequest(String url) async {
    print(url);
    var headers = await getHeaders();
    var request = client.get(Uri.parse(url), headers: headers);
    final response = await request;
    return response;
  }

  Future<http.Response> postRequest(String url, String body) async {
    debugPrint(url);
    var headers = await getHeaders();
    var request = client.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    final response = await request;
    return response;
  }

  Future<http.Response> putRequest(String url, {Map body = const {}}) async {
    print(url);
    var headers = await getHeaders();
    var request = client.put(
      Uri.parse(url),
      headers: headers,
      body: body.isEmpty ? null : jsonEncode(body),
    );
    final response = await request;
    return response;
  }

  Future<http.Response> deleteRequest(String url) async {
    print(url);
    var headers = await getHeaders();
    var request = client.delete(
      Uri.parse(url),
      headers: headers,
    );
    final response = await request;
    return response;
  }

  Future<String> getPortalURI() async {
    if (_portalName == null || _portalName.isEmpty) {
      _portalName = await _secureStorage.getString('portalName');
    }

    if (!_portalName.contains('http')) {
      _portalName = 'https://$_portalName';
      await savePortalName();
    }

    return _portalName;
  }

  Future<String> getToken() async {
    var token = await _secureStorage.getString('token');

    return token;
  }

  Future<void> savePortalName() async {
    await _secureStorage.putString('portalName', _portalName);
  }
}
