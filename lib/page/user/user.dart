import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_uas/model/modelUser.dart';
import 'package:provider/provider.dart';
import 'package:tugas_uas/model/modelUserOne.dart';
import 'package:tugas_uas/page/dashboard.dart';
import 'package:tugas_uas/page/user/input_user.dart';
import 'package:tugas_uas/provider/user.dart';
import 'package:sweetalert/sweetalert.dart';
import '../../model/string_http_exception.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import '../widget/popUpItem.dart';


class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  @override
  _UserState createState() => _UserState();


}

class _UserState extends State<User> {
  bool isLoading = false;
  List<ModelUser>? data;


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
     await Provider.of<UsersData>(context, listen: false).getUser();
    }on StringHttpException catch(error){
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    }catch(e){
      _showErrorDialog("Error \n $e !!");
    }
    setState(() {
      data = Provider.of<UsersData>(context, listen: false).data;
      isLoading = false;
    });
  }



  deleteData(id)async{
    try {
      await Provider.of<UsersData>(context, listen: false).deleteUser(id);
    }on StringHttpException catch(error){
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    }catch(e){
      _showErrorDialog("Error \n $e !!");
    }
    setState(() {
      bool deleted = Provider.of<UsersData>(context, listen: false).delete;
      if(deleted){
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
                  child: User()
              )
          );
        });
      }
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
              child: InputUser(val2.toString())
          )
      );
    }
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
          "List User",
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
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  child: Image.asset("assets/human.png"),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${data?[index].name}",
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black
                                      ),
                                    ),
                                    Text(
                                      data?[index].roleId == 1
                                      ? "Owner"
                                      : "Karyawan",
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: Colors.black,
                                        fontStyle: FontStyle.italic
                                      ),
                                    ),
                                  ],
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
                      child: InputUser("0")
                  )
              );
            },
          ),
        ),
      ),
    );
  }
}
