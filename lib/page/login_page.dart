import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/string_http_exception.dart';
import '../provider/login.dart';
import 'dashboard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginStatus{notSignIn, signIn}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  bool obscureText = true;
  bool isLoading = false;

  void _showErrorDialog(String message) {
    SweetAlert.show(
      context,
      subtitle: message,
      style: SweetAlertStyle.confirm,
    );
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      String? status = preferences.getString('loginStatus');
      _loginStatus = status == 'success' ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  postLogin()async{
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<Login>(context,listen: false).loginPage(username.text, password.text);
    }on StringHttpException catch(e){
      var errorMessage = e.toString();
      _showErrorDialog("Login Failed !! \n $errorMessage");
    }catch(e, s){
      _showErrorDialog("Login Failed !! $e");
      print(s.toString());
    }
    setState(() {
      isLoading = false;
      bool? login = Provider.of<Login>(context,listen: false).login;
      if(login == true){
        _loginStatus = LoginStatus.signIn;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch(_loginStatus){
      case LoginStatus.notSignIn :
        return Scaffold(
          backgroundColor: Colors.orange,
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(right: 10,left: 10),
                child: Container(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const[
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 20.0,
                            offset: Offset(0, 5)
                        )
                      ]
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Text(
                          "LOGIN !",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(
                                color: Colors.grey[100]!))
                        ),
                        child: TextField(
                          controller: username,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 14
                              )
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Username",
                              hintStyle: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  )
                              )
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(
                                color: Colors.grey[100]!))
                        ),
                        child: TextField(
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 14
                            ),
                          ),
                          obscureText: obscureText,
                          controller: password,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  )
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                child:
                                Icon(obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                    color: obscureText
                                        ? Colors.grey
                                        : Colors.orange[600]
                                ),
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 20),
                        child: isLoading
                            ? const SpinKitThreeBounce(
                          color: Colors.orange,
                          size: 40.0,
                        )
                            : TextButton(
                          onPressed: () {
                            if (username.text.isEmpty || password.text.isEmpty) {
                              _showErrorDialog("Username & Password Tidak Boleh Kosong !!");
                            } else {
                              postLogin();
                            }
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                 RoundedRectangleBorder(
                                  borderRadius:  BorderRadius.circular(10.0),
                                ),
                              )
                          ),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.orange[600]
                            ),
                            child: Center(
                              child: Text(
                                  "Sign In",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        break;
      case LoginStatus.signIn :
        return const Dashboard();
        break;
    }
  }
}
