import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tugas_uas/model/modelReport.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:provider/provider.dart';
import 'package:tugas_uas/page/transaksi/tambah_menu.dart';
import 'package:tugas_uas/provider/report.dart';
import 'package:tugas_uas/provider/transaksi.dart';
import '../../model/string_http_exception.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../dashboard.dart';
import '../widget/popUpItem.dart';


class Laporan extends StatefulWidget {
  const Laporan({Key? key}) : super(key: key);

  @override
  _LaporanState createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  bool isLoading = false;
  List<ModelReport>? data;
  List<int>? value;

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
      await Provider.of<Report>(context, listen: false).getReport();
    }on StringHttpException catch(error){
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    }catch(e){
      _showErrorDialog("Error \n $e !!");
    }
    setState(() {
      data = Provider.of<Report>(context, listen: false).report;
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text(
          "Laporan",
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold
              )
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: Dashboard()
                )
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            isLoading
                ? const Padding(
              padding: EdgeInsets.only(top: 40),
              child: SpinKitThreeBounce(
                color: Colors.orange,
                size: 40.0,
              ),
            )
                : Container(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 20,bottom: 20),
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: data?.length ?? 0,
                itemBuilder: ((BuildContext context, int index){
                  int i;
                  int total = 0;
                  for (i = 0; i < data![index].detail!.length; i++) {
                    total += data![index].detail![i].menu!.price!;
                  }


                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[500]!,
                              blurRadius: 10,
                              offset: Offset(0, 1)
                          )
                        ]
                    ),
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(top: 20,right: 15,left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Code : ",
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.black
                                  ),
                                ),
                                Text(
                                  "${data?[index].code}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Status : ",
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black
                          ),
                        ),
                        Text(
                          data?[index].status == 0
                              ? "Belum Bayar"
                              : "Sudah Bayar",
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: data?[index].status == 0
                                  ? Colors.red
                                  : Colors.green,
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold
                              )
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Total : ",
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black
                          ),
                        ),
                        Text(
                          data![index].detail!.isEmpty
                              ? "Rp -"
                              : "Rp ${total}",
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: data?[index].status == 0
                                  ? Colors.red
                                  : Colors.green,
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold
                              )
                          ),
                        ),

                      ],
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),

    );
  }
}
