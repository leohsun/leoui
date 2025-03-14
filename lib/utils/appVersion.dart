import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:leoui/widget/leoui_state.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersion {
  static final AppVersion _instance = AppVersion._();
  factory AppVersion() => _instance;
  AppVersion._();

  PackageInfo? _lcoalInfoData;
  String? _remoteUrl;

  Future<PackageInfo> get local async {
    if (_lcoalInfoData != null) return _lcoalInfoData!;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _lcoalInfoData = packageInfo;
    return packageInfo;
  }

  Future<String> get remoteUrl async {
    if (_remoteUrl != null) return _remoteUrl!;

    PackageInfo packageInfo = await local;

    late String remoteUrl;

    if (Platform.isIOS) {
      remoteUrl =
          "http://itunes.apple.com/br/lookup?bundleId=${packageInfo.packageName}";
    } else {
      remoteUrl =
          "https://play.google.com/store/apps/details?id=${packageInfo.packageName}&hl=en_US";
    }

    _remoteUrl = remoteUrl;
    return remoteUrl;
  }

  Future<String> get remote async {
    String url = await remoteUrl;
    try {
      final resp = await Dio(BaseOptions(connectTimeout: Duration(seconds: 10)))
          .get(url);

      if (Platform.isIOS) {
        final result = jsonDecode(resp.data);
        if (result["resultCount"] == 0) return "0";
        return result["results"][0]["version"];
      } else if (Platform.isAndroid) {
        final versionReg = RegExp(r'''\[\[\[["'](\d+(\.\d+)*)["']\]\]''');
        RegExpMatch? matchedVersion = versionReg.firstMatch(resp.data);
        String? version = matchedVersion?.group(1);
        return version != null ? version : "0";
      }

      return "0";
    } catch (err) {
      print(err);
      return "0";
    }
  }

  static int? compare(String a, String b) {
    final paramReg = RegExp(r'\d+(\.\d+)*');

    if (!paramReg.hasMatch(a) || !paramReg.hasMatch(b)) return null;

    try {
      List<int> bSplit =
          b.split('.').map((String intLike) => int.parse(intLike)).toList();
      List<int> aSplit =
          a.split('.').map((String intLike) => int.parse(intLike)).toList();
      int maxLength = max(bSplit.length, aSplit.length);

      for (int i = 0; i < maxLength; i++) {
        if (bSplit.index(i) == null) {
          bSplit.add(0);
        }

        if (aSplit.index(i) == null) {
          aSplit.add(0);
        }
      }

      for (int i = 0; i < bSplit.length; i++) {
        int b = bSplit[i];
        if (b > aSplit[i]) {
          return -1;
        } else if (b < aSplit[i]) {
          return 1;
        } else {
          continue;
        }
      }

      return 0;
    } catch (err) {
      return null;
    }
  }

  Future<bool> get hasLatestVersion async {
    final [current, online] = await Future.wait([
      local.then(
        (value) => value.version,
      ),
      remote
    ]);

    debugPrint(
        "current Version is: $current, remote Version is: $online (appVersion.dart)");

    return compare(online, current) == 1;
  }
}
