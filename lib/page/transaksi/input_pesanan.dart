import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tugas_uas/model/modelMenu.dart';
import 'package:tugas_uas/page/transaksi/tambah_menu.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:tugas_uas/provider/transaksi.dart';
import '../../model/string_http_exception.dart';
import '../../provider/base_url.dart';
import '../../provider/menu.dart';
import '../widget/textField.dart';

class InputPesanan extends StatefulWidget {
  final String? status;
  final int? id;
  const InputPesanan(this.status,this.id, {Key? key}) : super(key: key);

  @override
  _InputPesananState createState() => _InputPesananState();
}

class _InputPesananState extends State<InputPesanan> {
  bool isLoading = false;
  bool isLoading2 = false;
  List<ModelMenu>? data;
  ModelMenu? selected;
  TextEditingController jumlah = new TextEditingController();
  int? idValue;

  void _showErrorDialog(String message) {
    SweetAlert.show(
      context,
      subtitle: message,
      style: SweetAlertStyle.confirm,
    );
  }

  getData()async{
    setState((){
      isLoading = true;
    });
    try {
      await Provider.of<Menu>(context, listen: false).getMenu();
    }on StringHttpException catch(error){
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    }catch(e){
      _showErrorDialog("Error \n $e !!");
    }
    setState(() {
      data = Provider.of<Menu>(context, listen: false).menu;
      isLoading = false;
    });
  }

  postMenu(jumlah, id)async{
    setState((){
      isLoading2 = true;
    });
    try {
      await Provider.of<Transaksis>(context, listen: false).postPesanan(jumlah, id, widget.id);
    }on StringHttpException catch(error){
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    }catch(e){
      _showErrorDialog("Error \n $e !!");
      print(e);
    }
    setState(() {
      isLoading2 = false;
      bool? sucess = Provider.of<Transaksis>(context, listen: false).pesanan;

      if (sucess!) {
        SweetAlert.show(
          context,
          subtitle: "Berhasil Menyimpan Data !",
          style: SweetAlertStyle.success,
        );
        Timer(Duration(seconds: 2), ()
        {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: TambahMenu(widget.status)
              )
          );
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text(
          "Tambah Menu",
          style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold
              )
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: TambahMenu(widget.status)
                )
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLoading
            ? const SpinKitThreeBounce(
                color: Colors.orange,
                size: 40.0,
              )
            : Container(
              padding: EdgeInsets.only(right: 20,left: 20, bottom: 30, top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pilih Menu"),
                  DropdownButton<ModelMenu>(
                    hint: Text("Pilih Menu"),
                    value: selected,
                    items: data?.map((ModelMenu item) {
                      return DropdownMenuItem<ModelMenu>(
                        value: item,
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.network(
                                "${UrlApi.local + item.pic.toString()}",
                                width: 20,
                                height: 20,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(item.name.toString())
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (ModelMenu? value) {
                      setState(() {
                        selected = value;
                        idValue = value?.id;
                        print(idValue);
                      });
                    },
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 20,left: 20),
              child: TextFields("Jumlah",  jumlah, TextInputType.text, false),
            ),
            isLoading2
                ? const SpinKitThreeBounce(
              color: Colors.orange,
              size: 40.0,
            )
                : Center(
              child: Container(
                padding: EdgeInsets.only(right: 20,left: 20, bottom: 10,top: 20),
                child:  TextButton(
                  onPressed: () {
                    if(jumlah.value.text.isEmpty || idValue == null){
                      _showErrorDialog("Lengkapi Data");
                    }else{
                      postMenu(jumlah.value.text, idValue);
                    }
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius:  new BorderRadius.circular(10.0),
                        ),
                      )
                  ),
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.orange[300]
                    ),
                    child: Center(
                      child: Text(
                          "Submit",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 13
                            ),
                          )
                      ),
                    ),
                  ),
                ),
              ) ,
            )
          ],
        ),
      ),
    );
  }
}
