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

import 'package:event_hub/event_hub.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/viewstate.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/auth_token.dart';
import 'package:projects/data/models/from_api/capabilities.dart';
import 'package:projects/data/services/analytics_service.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/data/services/portal_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/data/services/storage/storage.dart';
import 'package:projects/domain/controllers/portalInfoController.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/authentication/2fa_sms/2fa_sms_screen.dart';
import 'package:projects/presentation/views/authentication/2fa_sms/enter_sms_code_screen.dart';
import 'package:projects/presentation/views/authentication/code_view.dart';
import 'package:projects/presentation/views/authentication/code_views/get_code_views.dart';
import 'package:projects/presentation/views/authentication/login_view.dart';

class LoginController extends GetxController {
  final AuthService _authService = locator<AuthService>();
  final PortalService _portalService = locator<PortalService>();
  final SecureStorage _secureStorage = locator<SecureStorage>();

  TextEditingController _portalAdressController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController get portalAdressController => _portalAdressController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  var portalFieldError = false.obs;
  var emailFieldError = false.obs;
  var passwordFieldError = false.obs;

  Capabilities capabilities;
  String _pass;
  String _email;
  String _tfaKey;

  String get portalAdress =>
      portalAdressController.text.replaceFirst('https://', '');
  String get tfaKey => _tfaKey;

  @override
  void onInit() {
    _portalAdressController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    super.onInit();
  }

  Future<void> loginByPassword() async {
    if (await _checkEmailAndPass()) {
      var email = _emailController.text;
      var password = _passwordController.text;

      setState(ViewState.Busy);

      var result = await _authService.login(email, password);

      if (result.response == null) {
        setState(ViewState.Idle);
        return;
      }
      if (result.response.token != null) {
        await saveToken(result);
        // need to save the token to send the device type
        if (await sendRegistrationType()) {
          setState(ViewState.Idle);
          clearInputFields();
          await AnalyticsService.shared.logEvent(
              AnalyticsService.Events.loginPortal, {
            AnalyticsService.Params.Key.portal:
                await _secureStorage.getString('portalName')
          });
          locator<EventHub>().fire('loginSuccess');
        } else {
          // if the device type has not been sent, the token must be deleted
          await logout();
        }
      } else if (result.response.tfa == true) {
        _email = email;
        _pass = password;
        setState(ViewState.Idle);

        if (result.response.tfaKey != null) {
          _tfaKey = result.response.tfaKey;
          await Get.to(() => const GetCodeViews());
        } else {
          await Get.to(() => CodeView());
        }
      } else if (result.response.sms == true) {
        _email = email;
        _pass = password;
        setState(ViewState.Idle);
        if (result.response.phoneNoise != null) {
          await Get.to(() => const EnterSMSCodeScreen(), arguments: {
            'phoneNoise': result.response.phoneNoise,
            'login': _email,
            'password': _pass
          });
        } else {
          await Get.to(() => const TFASmsScreen(),
              arguments: {'login': _email, 'password': _pass});
        }
      }
    }
  }

  Future<bool> _checkEmailAndPass() async {
    _emailController.text = _emailController.text.removeAllWhitespace;
    var result;

    emailFieldError.value = false;
    passwordFieldError.value = false;

    if (!_emailController.text.isEmail) {
      result = false;
      emailFieldError.value = true;
      // ignore: unawaited_futures
      900.milliseconds.delay().then((_) => emailFieldError.value = false);
      // save cursor position
      emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: emailController.text.length),
      );
    }
    if (_passwordController.text.isEmpty) {
      result = false;
      passwordFieldError.value = true;
      // ignore: unawaited_futures
      900.milliseconds.delay().then((_) => passwordFieldError.value = false);
    }
    return result ?? true;
  }

  Future saveToken(ApiDTO<AuthToken> result) async {
    await _secureStorage.putString('token', result.response.token);
    await _secureStorage.putString('expires', result.response.expires);
  }

  Future<bool> sendCode(String code, {String userName, String password}) async {
    setState(ViewState.Busy);

    code = code.removeAllWhitespace;
    _email ??= userName;
    _pass ??= password;

    var result = await _authService.confirmTFACode(_email, _pass, code);

    if (result.response == null) {
      setState(ViewState.Idle);
      return false;
    }

    if (result.response.token != null) {
      await saveToken(result);
      // need to save the token to send the device type
      if (await sendRegistrationType()) {
        setState(ViewState.Idle);
        clearInputFields();
        await AnalyticsService.shared.logEvent(
            AnalyticsService.Events.loginPortal, {
          AnalyticsService.Params.Key.portal:
              await _secureStorage.getString('portalName')
        });
        locator<EventHub>().fire('loginSuccess');
        return true;
      } else {
        // if the device type has not been sent, the token must be deleted
        await logout();
      }
    } else if (result.response.tfa) {
      setState(ViewState.Idle);
      await Get.to(() => CodeView());
      return true;
    }

    return false;
  }

  Future<void> getPortalCapabilities() async {
    _portalAdressController.text =
        _portalAdressController.text.removeAllWhitespace;

    if (!_portalAdressController.text.isURL) {
      portalFieldError.value = true;
      // ignore: unawaited_futures
      900.milliseconds.delay().then((_) => portalFieldError.value = false);
      _portalAdressController.selection = TextSelection.fromPosition(
        TextPosition(offset: _portalAdressController.text.length),
      );
    } else {
      setState(ViewState.Busy);

      var _capabilities =
          await _portalService.portalCapabilities(_portalAdressController.text);

      if (_capabilities != null) {
        capabilities = _capabilities;
        setState(ViewState.Idle);
        await Get.to(() => LoginView());
      } else {
        // to prevent socket exception
        _portalAdressController.dispose();
        _portalAdressController = TextEditingController();
      }

      setState(ViewState.Idle);
    }
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

  Future<bool> get isLoggedIn async => !await isTokenExpired();

  Future<bool> isTokenExpired() async {
    var expirationDate = await _secureStorage.getString('expires');
    var token = await _secureStorage.getString('token');
    var portalName = await _secureStorage.getString('portalName');

    if (expirationDate == null ||
        expirationDate.isEmpty ||
        token == null ||
        token.isEmpty ||
        portalName == null ||
        portalName.isEmpty) return true;

    var expiration = DateTime.parse(expirationDate);
    if (expiration.isBefore(DateTime.now())) return true;

    return false;
  }

  Future<bool> sendRegistrationType() async {
    var result = await _authService.sendRegistrationType();
    return result != null;
  }

  Future<void> logout() async {
    var storage = locator<Storage>();

    await _secureStorage.delete('expires');
    await _secureStorage.delete('portalName');
    await _secureStorage.delete('token');

    await storage.remove('taskFilters');
    await storage.remove('projectFilters');
    await storage.remove('discussionFilters');

    locator<EventHub>().fire('logoutSuccess');
    Get.find<PortalInfoController>().logout();
  }

  @override
  void onClose() {
    // clearInputFields();z
    _clearErrors();
    super.onClose();
  }

  void clearInputFields() {
    _portalAdressController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  void _clearErrors() {
    portalFieldError.value = false;
    emailFieldError.value = false;
    passwordFieldError.value = false;
  }
}
