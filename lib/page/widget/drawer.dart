import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tugas_uas/page/laporan/laporan.dart';
import 'package:tugas_uas/page/login_page.dart';
import 'package:tugas_uas/page/menu/menu.dart';
import 'package:tugas_uas/page/transaksi/transaksi.dart';
import 'package:tugas_uas/page/user/user.dart';
import 'package:sweetalert/sweetalert.dart';


class DrawerDashboard extends StatefulWidget {
  const DrawerDashboard({Key? key}) : super(key: key);

  @override
  _DrawerDashboardState createState() => _DrawerDashboardState();
}

class _DrawerDashboardState extends State<DrawerDashboard>with TickerProviderStateMixin{

  String? name = "";
  int? role;
  bool visibleUser = true;
  bool visibleMenu = true;
  bool visibleTransaksi = true;
  bool visibleLaporan = true;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('name');
      role = preferences.getInt("role");
      if(role == 2){
        visibleLaporan = false;
        visibleMenu = false;
        visibleUser = false;
      }
    });
  }

  Future<void> signOut()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
      prefs.setString("name", "");
      prefs.setString("loginStatus", "");
      prefs.setInt("id", 0);
      prefs.setInt("role", 0);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    });
  }

  void _showErrorDialog(String message) {
    SweetAlert.show(
        context,
        subtitle: message,
        style: SweetAlertStyle.confirm,
        showCancelButton: true,
        onPress: (bool isConfirm){
          if(isConfirm){
            signOut();
          }else{
            Navigator.pop(context);
          }
          return false;
        }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getPref();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0.0),
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
              color: Colors.orange[400]!,
          ),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey[200],
                  child: Image.asset('assets/human.png'),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: 'Hi, ',
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87
                        )
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: name,
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              )
                          )
                      ),
                    ],
                  ),
                ),
                Text(
                  role == 1
                    ? "Owner"
                    : "Karyawan",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      )
                  )
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: visibleUser,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!))
              ),
              child: InkWell(
                splashColor: Colors.orangeAccent,
                onTap: (){
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: User()
                      )
                  );
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.person_outline,
                      color: Colors.black87,
                    ),
                    SizedBox(width: 15),
                    Padding(
                      padding: EdgeInsets.only(right: 8,left: 5,top: 20,bottom: 20),
                      child: Text(
                          "User",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                          )
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: visibleMenu,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!))
              ),
              child: InkWell(
                splashColor: Colors.orangeAccent,
                onTap: (){
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: MenuPage()
                      )
                  );
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.fastfood_outlined,
                      color: Colors.black87,
                    ),
                    SizedBox(width: 15),
                    Padding(
                      padding: EdgeInsets.only(right: 8,left: 5,top: 20,bottom: 20),
                      child: Text(
                          "Daftar Menu",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                          )
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: visibleTransaksi,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!))
              ),
              child: InkWell(
                splashColor: Colors.orangeAccent,
                onTap: (){
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: Transaksi()
                      )
                  );
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.monetization_on_outlined,
                      color: Colors.black87,
                    ),
                    SizedBox(width: 15),
                    Padding(
                      padding: EdgeInsets.only(right: 8,left: 5,top: 20,bottom: 20),
                      child: Text(
                          "Transaksi",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                          )
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: visibleLaporan,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!))
              ),
              child: InkWell(
                splashColor: Colors.orangeAccent,
                onTap: (){
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: Laporan()
                      )
                  );
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.list_alt,
                      color: Colors.black87,
                    ),
                    SizedBox(width: 15),
                    Padding(
                      padding: EdgeInsets.only(right: 8,left: 5,top: 20,bottom: 20),
                      child: Text(
                          "Laporan",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                          )
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[300]!))
            ),
            child: InkWell(
              splashColor: Colors.orangeAccent,
              onTap: (){
               _showErrorDialog("Are You Sure To Logout ?");
              },
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.power_settings_new,
                    color: Colors.black87,
                  ),
                  SizedBox(width: 15),
                  Padding(
                    padding: EdgeInsets.only(right: 8,left: 5,top: 20,bottom: 20),
                    child: Text(
                        "Logout",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        )
                    ),
                  )
                ],
              ),
            ),
          ),
        )

      ],
    );
  }
}
