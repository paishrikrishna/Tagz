
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:android_id/android_id.dart';



class AuthenticationFunctions {

  Future<String?> phoneId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } 
    else if(Platform.isAndroid) {
      const _androidIdPlugin = AndroidId();
      final String? androidId = await _androidIdPlugin.getId();
      return androidId;
    }
    return "";
  }

}