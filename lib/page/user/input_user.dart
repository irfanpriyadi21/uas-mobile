import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tugas_uas/model/modelRoles.dart';
import 'package:tugas_uas/page/user/user.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:provider/provider.dart';
import 'package:tugas_uas/page/widget/textField.dart';
import 'package:tugas_uas/provider/roles.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tugas_uas/provider/user.dart';
import '../../model/modelUserOne.dart';
import '../../model/string_http_exception.dart';


class InputUser extends StatefulWidget {
  final String id;
  const InputUser(this.id, {Key? key}) : super(key: key);

  @override
  _InputUserState createState() => _InputUserState();
}

class _InputUserState extends State<InputUser> {
  bool isLoading = false;
  bool isLoading2 = false;
  bool visiblePassword = false;
  bool visibleRole = false;
  int? idValue;
  List<ModelRoles>? data = [];
  ModelRoles? selected;
  ModelUserOne? dataUser;
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController name = new TextEditingController();

  void _showErrorDialog(String message) {
    SweetAlert.show(
      context,
      subtitle: message,
      style: SweetAlertStyle.confirm,
    );
  }

  getDataByid()async{
    setState((){
      isLoading = true;
    });
    try {
      dataUser = await Provider.of<UsersData>(context, listen: false).getUserById(widget.id);
    }on StringHttpException catch(error){
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    }catch(e){
      _showErrorDialog("Error \n $e !!");
    }
    setState(() {
      username.text = "${dataUser?.data?.username}";
      name.text = "${dataUser?.data?.name}";
      isLoading = false;
    });
  }

  getRoles()async{
    setState((){
      isLoading = true;
    });
    try {
      await Provider.of<Roles>(context, listen: false).getRoles();
    }on StringHttpException catch(error){
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    }catch(e){
      _showErrorDialog("Error \n $e !!");
    }
    setState(() {
      data = Provider.of<Roles>(context, listen: false).data;
      isLoading = false;
    });
  }

  postUser(String username, String password, String name, int roleId)async{
    setState((){
      isLoading2 = true;
    });
    try {
      await Provider.of<UsersData>(context, listen: false).postUserData(username, password, name, roleId, widget.id);
    }on StringHttpException catch(error){
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    }catch(e){
      _showErrorDialog("Error \n $e !!");
    }
    setState(() {
      bool postUser = Provider.of<UsersData>(context, listen: false).postUser;
      isLoading2 = false;
      if(postUser){
        SweetAlert.show(
          context,
          subtitle: "Berhasil Menyimpan Data !",
          style: SweetAlertStyle.success,
        );
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getRoles();
    if(widget.id != "0"){
      this.getDataByid();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text(
          "Input User",
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
                    child: User()
                )
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 40,right: 20,left: 20, bottom: 10),
              child: TextFields("Username", username, TextInputType.text, false),
            ),
            Container(
              padding: EdgeInsets.only(right: 20,left: 20, bottom: 10),
              child: TextFields("password", password, TextInputType.text, false),
            ),
            Container(
              padding: EdgeInsets.only(right: 20,left: 20, bottom: 10),
              child: TextFields("Name",  name, TextInputType.text, false),
            ),
            isLoading
              ? SpinKitThreeBounce(
                  color: Colors.orange,
                  size: 30.0,
                )
              : Container(
              padding: EdgeInsets.only(right: 20,left: 20, bottom: 30),
              child: DropdownButton<ModelRoles>(
                hint: Text("Pilih Role"),
                value: selected,
                items: data?.map((ModelRoles item) {
                  return DropdownMenuItem<ModelRoles>(
                    value: item,
                    child: Text(item.name.toString()),
                  );
                }).toList(),
                onChanged: (ModelRoles? value) {
                  setState(() {
                    selected = value;
                    idValue = value?.id;
                  });
                },
              ),
            ),
            isLoading2
              ? const SpinKitThreeBounce(
                  color: Colors.orange,
                  size: 40.0,
                )
              : Center(
              child: Container(
                padding: EdgeInsets.only(right: 20,left: 20, bottom: 10),
                child:  TextButton(
                  onPressed: () {
                    if(widget.id != "0"){
                      postUser(username.value.text, password.value.text, name.value.text, idValue!);
                    }else{
                      if(username.value.text.isEmpty || password.text.isEmpty || name.text.isEmpty || idValue == null){
                        _showErrorDialog("Lengkapi Data");
                      }else{
                        postUser(username.value.text, password.value.text, name.value.text, idValue!);
                      }
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
        )
      ),
    );
  }
}
