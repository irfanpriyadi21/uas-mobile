import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tugas_uas/model/ModelTransaksiOne.dart';
import 'package:tugas_uas/provider/base_url.dart';
import 'package:http/http.dart' as http;

class Transaksis with ChangeNotifier{
  bool? postTransaksi;
  bool? hapusTransaksi;
  bool? bayar;
  bool? pesanan;

  Future<void> addTransaksi()async{
    final url = UrlApi.transaksi;
    try{
      final response = await http.post(
          Uri.parse(url));
      final responseData = json.decode(response.body);
      print(responseData);
      if(responseData["status"] == "success"){
        postTransaksi = true;
      }else{
        postTransaksi = false;
      }

    }catch(e){
      rethrow;
    }
  }

  Future<void> deleteTransaksi(id)async{
    final url = UrlApi.transaksi + "/$id";
    try{
      final response = await http.delete(Uri.parse(url));
      final responseData = json.decode(response.body);
      print(responseData);
      if(responseData["status"] == "success"){
        hapusTransaksi = true;
      }else{
        hapusTransaksi = false;
      }

    }catch(e){
      rethrow;
    }
  }

  Future<ModelTransaksiOne?> getById(id)async{
    final url = UrlApi.transaksi + "/$id";
    try{
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        print(response.body);
        final responseData = json.decode(response.body);
        ModelTransaksiOne userData = ModelTransaksiOne.fromJson(responseData);
        return userData;

      }else{
        return null;
      }
    }catch(e){
      rethrow;
    }
  }

  Future<void> bayarPesanan(id)async{
    final url = UrlApi.transaksi + "/pay/$id";
    try{
      final response = await http.post(
          Uri.parse(url));
      final responseData = json.decode(response.body);
      print(responseData);
      if(responseData["status"] == "success"){
        bayar = true;
      }else{
        bayar = false;
      }

    }catch(e){
      rethrow;
    }
  }

  Future<void> postPesanan(jumlah, idmenu, idData)async{
    final url = UrlApi.transaksi + "/add-menu/$idData";
    print(url);
    print(idmenu);
    try{
      final response = await http.post(
          Uri.parse(url),
        body: {
            "menu_id" : idmenu.toString(),
            "qty" : jumlah.toString()
        }
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if(responseData["status"] == "success"){
        pesanan = true;
      }else{
        pesanan = false;
      }

    }catch(e){
      rethrow;
    }
  }
}