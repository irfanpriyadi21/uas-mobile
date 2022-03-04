import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tugas_uas/model/modelReport.dart';
import 'package:tugas_uas/provider/base_url.dart';
import 'package:http/http.dart'as http;

class Report with ChangeNotifier{

  List<ModelReport>? report = [];

  Future<void> getReport()async{
    final url= UrlApi.report;
    try{
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        final responseData = json.decode(response.body);
        Iterable data = responseData['data'];
        report = data.map((e) => ModelReport.fromJson(e)).toList();
      }else{
        return null;
      }
    }catch(e){
      rethrow;
    }

  }

}