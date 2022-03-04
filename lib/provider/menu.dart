import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:tugas_uas/model/modelMenuOne.dart';
import 'package:tugas_uas/provider/base_url.dart';
import 'package:http/http.dart' as http;
import '../model/modelMenu.dart';
import '../model/string_http_exception.dart';

class Menu with ChangeNotifier{
  List<ModelMenu>? menu = [];
  bool? delete;
  bool? postMenu;

  Future<void> getMenu()async{
    final url = UrlApi.menu;
    try{
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        final responseData = json.decode(response.body);
        Iterable data = responseData['data'];
        menu = data.map((e) => ModelMenu.fromJson(e)).toList();
      }else{
        return null;
      }
    }catch(e){
      rethrow;
    }
  }

  Future<void> inputMenu(String name, String desc, String price, File image, String id)async{
    String url = "";
    if(id != "0"){
      url = UrlApi.menu + "/$id";
    }else{
      url = UrlApi.menu;
    }

    try{
      final request = http.MultipartRequest("POST", Uri.parse(url));
     request.fields["name"] = name.toString();
     request.fields["desc"] = desc.toString();
     request.fields["price"] = price.toString();
     var pic = await http.MultipartFile.fromPath("pic", image.path);
     request.files.add(pic);
     var responsed = await request.send();
     var responseData = await responsed.stream.toBytes();
     var responseString = String.fromCharCodes(responseData);
     print(responseString);

     final responseDatas = json.decode(responseString);
     String status = responseDatas['status'];
       if(status == "success"){
         postMenu = true;
       }else{
         postMenu = false;
         throw StringHttpException("Gagal Upload Data !");
       }
    }catch(e){
      rethrow;
    }
  }

  Future<void> deleteMenu(id)async{
    final url = UrlApi.menu + "/$id";
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

  Future<ModelMenuOne?>getMenuById(String id)async{
    final url = UrlApi.menu + "/$id";
    try{
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        final responseData = json.decode(response.body);
        ModelMenuOne menu = ModelMenuOne.fromJson(responseData);
        return menu;
      }else{
        return null;
      }
    }catch(e){
      rethrow;
    }
  }
}