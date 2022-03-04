

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tugas_uas/model/modelRoles.dart';
import 'package:tugas_uas/page/menu/menu.dart';
import 'package:tugas_uas/page/user/user.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:provider/provider.dart';
import 'package:tugas_uas/page/widget/textField.dart';
import 'package:tugas_uas/provider/base_url.dart';
import 'package:tugas_uas/provider/menu.dart';
import 'package:tugas_uas/provider/roles.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tugas_uas/provider/user.dart';
import '../../model/modelMenuOne.dart';
import '../../model/modelUserOne.dart';
import '../../model/string_http_exception.dart';
import 'package:image_picker/image_picker.dart';


class InputMenu extends StatefulWidget {
  final String id;
  const InputMenu(this.id, {Key? key}) : super(key: key);

  @override
  _InputMenuState createState() => _InputMenuState();
}

class _InputMenuState extends State<InputMenu> {
  var _image;
  var imagePicker;
  ModelMenuOne? menu;
  var type;
  String? urlImg;
  bool isLoading = false;
  bool isLoading2 = false;
  bool visiblePassword = false;
  bool visibleRole = false;
  TextEditingController name = new TextEditingController();
  TextEditingController deskripsi = new TextEditingController();
  TextEditingController price = new TextEditingController();

  void _showErrorDialog(String message) {
    SweetAlert.show(
      context,
      subtitle: message,
      style: SweetAlertStyle.confirm,
    );
  }

  Future getImage() async {
    var source = ImageSource.gallery;
    XFile image = await imagePicker.pickImage(
        source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
    setState(() {
      _image = File(image.path);
    });
  }

  getMenuByid()async{
    setState((){
      isLoading = true;
    });
    try {
      menu = await Provider.of<Menu>(context, listen: false).getMenuById(widget.id);
    }on StringHttpException catch(error){
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    }catch(e){
      _showErrorDialog("Error \n $e !!");
    }
    setState(() {
      name.text = "${menu?.data?.name}";
      deskripsi.text = "${menu?.data?.desc}";
      price.text = "${menu?.data?.price}";
      urlImg = "${menu?.data?.pic}";
      isLoading = false;
    });
  }


  postMenu(String name, String desc, String price)async{
    setState((){
      isLoading2 = true;
    });
    try {
      await Provider.of<Menu>(context, listen: false).inputMenu(name, desc, price, _image, widget.id);
    }on StringHttpException catch(error){
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    }catch(e){
      _showErrorDialog("Error \n $e !!");
    }
    setState(() {
      bool? sucess = Provider.of<Menu>(context, listen: false).postMenu;
      isLoading2 = false;
      if(sucess!){
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
    imagePicker = new ImagePicker();
    if(widget.id != "0"){
      this.getMenuByid();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text(
          "Input Menu",
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
                    child: MenuPage()
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
                child: TextFields("Nama Menu", name, TextInputType.text, false),
              ),
              Container(
                padding: EdgeInsets.only(right: 20,left: 20, bottom: 10),
                child: TextFields("Deskripsi", deskripsi, TextInputType.text, false),
              ),
              Container(
                padding: EdgeInsets.only(right: 20,left: 20, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Foto",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: (){
                        print("asas");
                        getImage();
                      },
                      child: Container(
                        height: 80,
                        width: 100,
                        child: urlImg == null
                            ? _image != null
                              ? Image.file(
                                  _image,
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.fitHeight,
                                )
                              : Image.asset("assets/add_image.png")
                        : _image != null
                          ? Image.file(
                          _image,
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.fitHeight,
                        )
                          : Image.network("${UrlApi.local + urlImg!}")
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 20,left: 20, bottom: 10),
                child: TextFields("Harga",  price, TextInputType.text, false),
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
                       postMenu(name.value.text, deskripsi.value.text, price.value.text);
                     }else{
                       if(name.value.text.isEmpty || deskripsi.text.isEmpty || price.text.isEmpty || _image == null){
                         _showErrorDialog("Lengkapi Data");
                       }else{
                         postMenu(name.value.text, deskripsi.value.text, price.value.text);
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
