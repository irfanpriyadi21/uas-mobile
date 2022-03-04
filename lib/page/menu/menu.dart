import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tugas_uas/model/modelMenu.dart';
import 'package:tugas_uas/page/menu/input_menu.dart';
import 'package:tugas_uas/provider/base_url.dart';
import 'package:tugas_uas/provider/menu.dart';
import '../../model/string_http_exception.dart';
import '../dashboard.dart';
import 'package:provider/provider.dart';
import 'package:sweetalert/sweetalert.dart';

import '../widget/popUpItem.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool isLoading = false;
  List<ModelMenu>? data;

  void _showErrorDialog(String message) {
    SweetAlert.show(
      context,
      subtitle: message,
      style: SweetAlertStyle.confirm,
    );
  }

  deleteData(id)async{
    try {
      await Provider.of<Menu>(context, listen: false).deleteMenu(id);
    }on StringHttpException catch(error){
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    }catch(e){
      _showErrorDialog("Error \n $e !!");
    }
    setState(() {
      bool? deleted = Provider.of<Menu>(context, listen: false).delete;
      if(deleted!){
        SweetAlert.show(
          context,
          subtitle: "Berhasil Menghapus Data !",
          style: SweetAlertStyle.success,
        );
        Timer(Duration(seconds: 1), () {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: MenuPage()
              )
          );
        });
      }
    });
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

  choiceAction(value,val2){
    if(value == "delete"){
      deleteData(val2);
    }else if(value == "edit"){
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: InputMenu(val2.toString())
          )
      );
    }
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
          "List Menu",
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    "${UrlApi.local + data![index].pic.toString()}",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "${data?[index].name}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.black
                                  ),
                                ),

                              ],
                            ),
                            PopupMenuButton(
                              onSelected: (value){
                                choiceAction(value, data?[index].id);
                              },
                              offset: Offset(0, 50),
                              itemBuilder: (context) {
                                return const[
                                  PopupMenuItem(
                                    child: WidgetPopUpItems("Delete", CupertinoIcons.trash),
                                    value: 'delete',
                                  ),
                                  PopupMenuItem(
                                    child: WidgetPopUpItems("Edit", Icons.edit),
                                    value: 'edit',
                                  ),
                                ];
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${data?[index].desc}",
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.grey
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Harga Rp ${data?[index].price}",
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black
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
      floatingActionButton: Container(
        width: 55.0,
        height: 55.0,
        child: FittedBox(
          child: FloatingActionButton(
            child: Icon(Icons.add, color: Colors.white),
            backgroundColor: Colors.orange,
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: InputMenu("0")
                  )
              );
            },
          ),
        ),
      ),
    );
  }
}
