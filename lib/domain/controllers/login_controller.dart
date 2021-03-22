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

import 'dart:async';

import 'package:get/get.dart';
import 'package:projects/data/enums/viewstate.dart';
import 'package:projects/data/models/from_api/capabilities.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/data/services/portal_service.dart';
import 'package:projects/data/services/storage.dart';
import 'package:projects/internal/locator.dart';

class LoginController extends GetxController {
  final AuthService _authService = locator<AuthService>();

  final PortalService _portalService = locator<PortalService>();
  final Storage _storage = locator<Storage>();

  Capabilities capabilities;
  String _portalName;
  String _pass;
  String _email;

  bool _tokenExpired;

  @override
  void onInit() {
    super.onInit();
    setState(ViewState.Busy);
    Future.wait([isTokenExpired()]).then((value) => {
          _tokenExpired = value[0],
          setState(ViewState.Idle),
          if (!_tokenExpired) Get.offNamed('NavigationView'),
        });
  }

  Future<void> loginByPassword(String email, String password) async {
    setState(ViewState.Busy);

    var result = await _authService.login(email, password);

    if (result.response.token != null) {
      setState(ViewState.Idle);
      Get.offNamed('NavigationView');
    } else if (result.response.tfa) {
      setState(ViewState.Idle);
      _email = email;
      _pass = password;

      Get.toNamed('CodeView');
    }
    setState(ViewState.Idle);
  }

  Future<void> sendCode(String code) async {
    setState(ViewState.Busy);

    var result = await _authService.confirmTFACode(_email, _pass, code);

    if (result.response.token != null) {
      setState(ViewState.Idle);
      Get.toNamed('HomeView');
    } else if (result.response.tfa) {
      setState(ViewState.Idle);
      Get.toNamed('CodeView');
    }
  }

  Future<void> loginByProvider(String provider) async {
    switch (provider) {
      case 'google':
        try {
          var result = await _authService.signInWithGoogle();
        } catch (e) {}

        break;
      case 'facebook':
      // var result = await _authenticationService.signInWithFacebook();
      // break;
      case 'twitter':
      // var result = await _authenticationService.signInWithTwitter();
      // break;
      case 'linkedin':

      case 'mailru':

      case 'vk':

      case 'yandex':

      case 'gosuslugi':

      default:
    }
  }

  getPortalCapabilities(String portalName) async {
    setState(ViewState.Busy);
    _portalName = portalName;

    var _capabilities = await _portalService.portalCapabilities(portalName);

    if (_capabilities != null) {
      capabilities = _capabilities;
      Get.toNamed('LoginView');
    }

    setState(ViewState.Idle);
    return true;
  }

  String emailValidator(value) {
    if (value.isEmpty) return 'Введите корректный email';

    /// regex pattern to validate email inputs.
    final Pattern _emailPattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]";

    if (RegExp(_emailPattern).hasMatch(value)) return null;

    return 'Введите корректный email';
  }

  String passValidator(value) {
    if (!value.isEmpty) return null;
    return 'Введите пароль';
  }

  var state = ViewState.Idle.obs;

  void setState(ViewState viewState) {
    state.value = viewState;
  }

  Future<bool> isTokenExpired() async {
    String expirationDate = await _storage.getString('expires');
    String token = await _storage.getString('token');
    String portalName = await _storage.getString('portalName');

    if (expirationDate == null ||
        expirationDate.isEmpty ||
        token == null ||
        token.isEmpty ||
        portalName == null ||
        portalName.isEmpty) return true;

    DateTime expiration = DateTime.parse(expirationDate);
    if (expiration.isBefore(DateTime.now())) return true;

    return false;
  }
}
