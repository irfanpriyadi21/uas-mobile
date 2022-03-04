import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:tugas_uas/model/modelRoles.dart';
import 'base_url.dart';

class Roles with ChangeNotifier{
  List<ModelRoles>? data = [];
  bool delete = false;

  Future<void>getRoles()async{
    final url = UrlApi.roles;
    try{
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        final responseData = json.decode(response.body);
        Iterable user = responseData['data'];
        data = user.map((e) => ModelRoles.fromJson(e)).toList();
      }else{
        return null;
      }
    }catch(e){
      rethrow;
    }
  }
}