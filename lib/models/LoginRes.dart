import 'dart:ffi';

class LoginRes {
  late String token;
  late String roles;
  late String refreshToken;
  late int uid;
  late int id;
  LoginRes(this.token, this.roles, this.refreshToken, this.uid, this.id);
  LoginRes.fromJson(Map<String, dynamic> body) {
    token = body["token"];
    roles = body["roles"][0];
    refreshToken = body["refreshToken"];
    uid = body["uid"] ?? 0;
    id = body["id"] ?? 0;
  }
}
