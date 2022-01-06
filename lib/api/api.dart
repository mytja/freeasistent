import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

const String eAsUrl = 'https://www.easistent.com';

const Map<String, String> MobilePayload = {
  'content-type': 'application/json',
  'x-app-name': 'family',
  'x-client-version': '20001',
  'x-client-platform': 'android',
};

const Map<String, String> WebPayload = {
  'content-type': 'application/json',
  'x-app-name': 'family',
  'x-client-version': '13',
  'x-client-platform': 'web',
};

class UserData {
  UserData({required this.access_token, required this.id});

  final String id;
  final String access_token;
}

Future<UserData?> getToken() async {
  String? token = await storage.read(key: "token");
  print(token);
  if (token == null) {
    return null;
  }
  var response = await Dio().post(
    '$eAsUrl/m/refresh_token',
    data: jsonEncode({'refresh_token': token}),
    options: Options(headers: MobilePayload),
  );
  print(response.data);

  String refresh_token = response.data["refresh_token"];
  await storage.write(key: "token", value: refresh_token);

  return UserData(
    access_token: response.data["access_token"]["token"],
    id: (await storage.read(key: "userId"))!,
  );
}

Future<UserData?> login(String username, String password) async {
  var response = await Dio().post('$eAsUrl/m/login',
      data: jsonEncode({
        'username': username,
        'password': password,
        'supported_user_types': ['child'],
      }),
      options: Options(headers: MobilePayload));
  if (response.data["access_token"] != null) {
    await storage.write(key: "token", value: response.data["refresh_token"]);
    await storage.write(
        key: "userId", value: response.data["user"]["id"].toString());
    return UserData(
      access_token: response.data["access_token"]["token"],
      id: response.data["user"]["id"].toString(),
    );
  }
  return null;
}
