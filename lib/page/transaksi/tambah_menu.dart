import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tugas_uas/model/ModelTransaksiOne.dart';
import 'package:tugas_uas/page/transaksi/input_pesanan.dart';
import 'package:tugas_uas/page/transaksi/transaksi.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tugas_uas/provider/transaksi.dart';

import '../../model/string_http_exception.dart';

class TambahMenu extends StatefulWidget {
  final String? id;
  const TambahMenu(this.id, {Key? key}) : super(key: key);

  @override
  _TambahMenuState createState() => _TambahMenuState();
}

class _TambahMenuState extends State<TambahMenu> {
  bool isLoading = false;
  bool isLoading2 = false;
  ModelTransaksiOne? trans;


  void _showErrorDialog(String message) {
    SweetAlert.show(
      context,
      subtitle: message,
      style: SweetAlertStyle.confirm,
    );
  }

  bayar()async{
    setState(() {
      isLoading2 = true;
    });
    try {
      await Provider.of<Transaksis>(context, listen: false).bayarPesanan(widget.id);
    }on StringHttpException catch(error){
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    }catch(e){
      _showErrorDialog("Error \n $e !!");
    }
    setState(() {
      isLoading2 = false;
      bool? bayar = Provider.of<Transaksis>(context, listen: false).bayar;
      if(bayar!){
        SweetAlert.show(
          context,
          subtitle: "Berhasil !",
          style: SweetAlertStyle.success,
        );
        Timer(Duration(seconds: 2), ()
        {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: Transaksi()
              )
          );
        });
      }else{
        _showErrorDialog("Gagal Menambah Data");
      }
    });
  }

  getMenuByid()async{
    setState((){
      isLoading = true;
    });
    try {
      trans = await Provider.of<Transaksis>(context, listen: false).getById(widget.id.toString());
    }on StringHttpException catch(error){
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    }catch(e){
      _showErrorDialog("Error \n $e !!");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    this.getMenuByid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text(
          "Pesanan",
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
                    child: Transaksi()
                )
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Detail Pesanan",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      )
                  ),
                ),
              ),
              if (isLoading) const SpinKitThreeBounce(
                  color: Colors.orange,
                  size: 40.0,
                ) else Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Row(
                        children: [
                          Text(
                            "Id :",
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                )
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "${trans!.data!.id}",
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        children: [
                          Text(
                            "Code :",
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                )
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "${trans!.data!.code}",
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                    Text(
                      "List Pesanan :",
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          )
                      ),
                    ),
                    ListView.builder(
                      padding: EdgeInsets.only(top: 20,bottom: 20),
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: trans!.data?.detail?.length ?? 0,
                      itemBuilder: ((BuildContext context, int index){
                        final data = trans!.data!.detail![index];


                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "- ${data.menu!.name!}",
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    )
                                ),
                              ),
                              SizedBox(width: 20),
                              Text(
                                "Rp ${data.menu!.price!}",
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    )
                                ),
                              )
                            ],
                          ),
                        );
                       })
                    ),
                    SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: InputPesanan(widget.id, trans!.data!.id!)
                                )
                            );
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                new RoundedRectangleBorder(
                                  borderRadius:  new BorderRadius.circular(10.0),
                                ),
                              )
                          ),
                          child: Container(
                            height: 45,
                            width: 140,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue[300]
                            ),
                            child: Center(
                              child: Text(
                                  "Tambah Pesanan",
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
                        isLoading2
                        ? SpinKitThreeBounce(
                            color: Colors.orange,
                            size: 40.0,
                          )
                        : TextButton(
                          onPressed: () {
                            bayar();
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                new RoundedRectangleBorder(
                                  borderRadius:  new BorderRadius.circular(10.0),
                                ),
                              )
                          ),
                          child: Container(
                            height: 45,
                            width: 90,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.orange[300]
                            ),
                            child: Center(
                              child: Text(
                                  "Bayar",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13
                                    ),
                                  )
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
