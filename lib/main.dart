import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_uas/page/dashboard.dart';
import 'package:tugas_uas/page/login_page.dart';
import 'package:tugas_uas/page/transaksi/transaksi.dart';
import 'package:tugas_uas/provider/AppProvider.dart';
import 'package:tugas_uas/provider/login.dart';
import 'package:tugas_uas/provider/menu.dart';
import 'package:tugas_uas/provider/report.dart';
import 'package:tugas_uas/provider/roles.dart';
import 'package:tugas_uas/provider/transaksi.dart';
import 'package:tugas_uas/provider/user.dart';
import 'package:tugas_uas/util/const.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider())
        ],
        child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider.value(
            value: UsersData()
        ),
        ChangeNotifierProvider.value(
            value: Login()
        ),
        ChangeNotifierProvider.value(
            value: Roles()
        ),
        ChangeNotifierProvider.value(
            value: Menu()
        ),
        ChangeNotifierProvider.value(
            value: Report()
        ),
        ChangeNotifierProvider.value(
            value: Transaksis()
        ),
      ],
      child: Consumer<AppProvider>(
          builder: (BuildContext context, AppProvider appProvider, Widget child){
            return MaterialApp(
              key: appProvider.key,
              theme: ThemeData(
                primarySwatch: Colors.orange,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              debugShowCheckedModeBanner: false,
              navigatorKey: appProvider.navigatorKey,
              title: Constants.appName,
              home: const LoginPage(),
            );
          }
      ),
    );
  }
}

