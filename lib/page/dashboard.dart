import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_uas/page/laporan/laporan.dart';
import 'package:tugas_uas/page/menu/menu.dart';
import 'package:tugas_uas/page/transaksi/transaksi.dart';
import 'package:tugas_uas/page/user/user.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tugas_uas/page/widget/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int? role;
  bool visibleUser = true;
  bool visibleMenu = true;
  bool visibleTransaksi = true;
  bool visibleLaporan = true;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      role = preferences.getInt("role");
      if(role == 2){
        visibleLaporan = false;
        visibleMenu = false;
        visibleUser = false;
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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Tugas Uas",
          style: GoogleFonts.poppins(),
        ),
      ),
      drawer: new Drawer(
        child: DrawerDashboard(),
      ),
      body: Column(
        children: [
          Expanded(child:
          GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.only(top: 40),
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,

            children: [
              Visibility(
                visible: visibleTransaksi,
                child:  GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: Transaksi()
                        )
                    );
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.monetization_on_outlined,size: 40),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Transaksi",
                            style: GoogleFonts.poppins(),
                          ),
                        ],
                      )
                  ),
                ),
              ),
              Visibility(
                visible: visibleUser,
                child: GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: User()
                    )
                );
              },
              child: Container(
                  margin: EdgeInsets.only(right: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        child: Image.asset("assets/human.png"),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "User",
                        style: GoogleFonts.poppins(),
                      ),
                    ],
                  )
              ),
            )
              ),
              Visibility(
                  visible: visibleMenu,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: MenuPage()
                          )
                      );
                    },
                    child:  Container(
                        margin: EdgeInsets.only(left: 20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              child: Image.asset("assets/product.png"),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Menu",
                              style: GoogleFonts.poppins(),
                            ),
                          ],
                        )
                    ),
                  ),
              ),
              Visibility(
                  visible: visibleLaporan,
                  child:  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: Laporan()
                          )
                      );
                    },
                    child:  Container(
                        margin: EdgeInsets.only(right: 20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              child: Icon(Icons.list_alt,size: 40),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Report",
                              style: GoogleFonts.poppins(),
                            ),
                          ],
                        )
                    ),
                  ),
              ),



            ],
          ))
        ],
      )
    );
  }
}
