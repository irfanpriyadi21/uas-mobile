import 'package:flutter/cupertino.dart';
import 'package:tugas_uas/model/modelUser.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/modelUserOne.dart';
import 'base_url.dart';

class UsersData with ChangeNotifier{
  List<ModelUser>? data = [];
  bool delete = false;
  bool postUser = false;

  Future<void>getUser()async{
    final url = UrlApi.user;
    try{
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        final responseData = json.decode(response.body);
        Iterable user = responseData['data'];
        data = user.map((e) => ModelUser.fromJson(e)).toList();
      }else{
        return null;
      }
    }catch(e){
      rethrow;
    }
  }

  Future<void> deleteUser(id)async{
    final url = UrlApi.user + "/$id";
    print(url);
    try{
      final response = await http.delete(Uri.parse(url));
      final responseData = json.decode(response.body);
      print(responseData);
      if(responseData["status"] == "success"){
        delete = true;
      }else{
        delete = false;
      }
    }catch(e){
      rethrow;
    }
  }

  Future<void> postUserData(String username, String password, String name, int role_id, String id)async{
    String url = "";
    if(id == "0"){
     url = UrlApi.user;
    }else{
      url = UrlApi.user + "/$id";
    }
    try{
      final response = await http.post(
          Uri.parse(url),
          body: {
            "username" : username,
            "password" : password,
            "name" : name,
            "role_id" : role_id.toString()
          }
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if(responseData["status"] == "success"){
        postUser = true;
      }else{
        postUser = false;
      }
    }catch(e){
      rethrow;
    }
  }

  Future<ModelUserOne?>getUserById(String id)async{
    final url = UrlApi.user + "/$id";
    try{
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        final responseData = json.decode(response.body);
        ModelUserOne userData = ModelUserOne.fromJson(responseData);
        return userData;
      }else{
        return null;
      }
    }catch(e){
      rethrow;
    }
  }



}