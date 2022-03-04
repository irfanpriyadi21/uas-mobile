import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tugas_uas/provider/base_url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/string_http_exception.dart';

class Login with ChangeNotifier {
  bool? login;

  Future<void>loginPage(String? username, String? password)async{
    final url = UrlApi.login;
    try{
      print(url);
      final response = await http.post(
        Uri.parse(url),
        body: {
          "username" : username,
          "password" : password
        }
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if(responseData['status'] == "success"){
        final data = responseData['data'];
        login = true;
        int id = data['id'];
        String name = data['name'];
        int role = data['role_id'];
        String loginStatus = 'success';
        sharedPreferences(name, loginStatus, id, role);
        notifyListeners();
      }else{
        login = false;
        throw StringHttpException(responseData['error']);
      }
    }catch(e){
      rethrow;
    }
  }

  sharedPreferences(String? name, String?loginStatus, int? id, int? role)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name", name!);
    prefs.setString("loginStatus", loginStatus!);
    prefs.setInt("id", id!);
    prefs.setInt("role", role!);
  }
}