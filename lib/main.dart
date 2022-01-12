// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:local/src/pages/home/home_page.dart';
import 'package:local/src/pages/login/login_page.dart';
import 'package:local/src/pages/productor/edit/productor_edit_page.dart';
import 'package:local/src/pages/productor/history/productor_history_page.dart';
import 'package:local/src/pages/productor/history_detail/productor_history_detail_page.dart';
import 'package:local/src/pages/productor/ingresop/productor_ingresop_page.dart';
import 'package:local/src/pages/productor/map/productor_map_page.dart';
import 'package:local/src/pages/productor/register/productor_register_page.dart';
import 'package:local/src/pages/productor/viaje_calification/productor_viaje_calification_page.dart';
import 'package:local/src/pages/productor/viaje_info/productor_viaje_info_page.dart';
import 'package:local/src/pages/productor/viaje_map/productor_viaje_map_page.dart';
import 'package:local/src/pages/productor/viaje_request/productor_viaje_request_page.dart';
import 'package:local/src/pages/reciclador/edit/reciclador_edit_page.dart';
import 'package:local/src/pages/reciclador/history/reciclador_history_page.dart';
import 'package:local/src/pages/reciclador/history_detail/reciclador_history_detail_page.dart';
import 'package:local/src/pages/reciclador/map/reciclador_map_page.dart';
import 'package:local/src/pages/reciclador/register/reciclador_register_page.dart';
import 'package:local/src/pages/reciclador/viaje_calification/reciclador_viaje_calification_page.dart';
import 'package:local/src/pages/reciclador/viaje_map/reciclador_viaje_map_page.dart';
import 'package:local/src/pages/reciclador/viaje_request/reciclador_viaje_request_page.dart';
import 'package:local/src/providers/analytics_service.dart';
import 'package:local/src/providers/push_notifications_provider.dart';
import 'package:local/src/utils/colors.dart' as utils;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {


  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<NavigatorState> navigatorKey= new GlobalKey<NavigatorState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();
    pushNotificationsProvider.initPushNotifications();
    pushNotificationsProvider.message.listen((data) {
      print('---------------NOTIFICACION NUEVA--------------');
      print(data);
      navigatorKey.currentState.pushNamed('reciclador/viaje/request', arguments: data);
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'reciecu',
      navigatorKey: navigatorKey,

      initialRoute: 'home',
        navigatorObservers: [AnalyticsService().getAnalyticsObserver()],
        //initialRoute: 'productor/travel/calification',
      theme: ThemeData (
        //fontFamily: 'GrandHotel',
        appBarTheme: AppBarTheme(
          elevation: 0
        ),
            primaryColor: utils.Colors.uberCloneColor
      ),
      routes:  {
        'home' : (BuildContext context) => HomePage(),
        'login' : (BuildContext context) => LoginPage(),
        'productor/register' : (BuildContext context) => ProductorRegisterPage(),
        'reciclador/register' : (BuildContext context) => RecicladorRegisterPage(),
        'reciclador/map' : (BuildContext context) => RecicladorMapPage(),
        'reciclador/viaje/request' : (BuildContext context) => RecicladorViajeRequestPage(),
        'reciclador/viaje/map' : (BuildContext context) => RecicladorViajeMapPage(),
        'reciclador/viaje/calification' : (BuildContext context) => RecicladorViajeCalificationPage(),
        'reciclador/edit' : (BuildContext context) => RecicladorEditPage(),
        'reciclador/history' : (BuildContext context) => RecicladorHistoryPage(),
        'reciclador/history/detail' : (BuildContext context) => RecicladorHistoryDetailPage(),
        'productor/map' : (BuildContext context) => ProductorMapPage(),
        'productor/viaje/info' : (BuildContext context) => ProductorViajeInfoPage(),
        'productor/viaje/request' : (BuildContext context) => ProductorViajeRequestPage(),
        'productor/viaje/map' : (BuildContext context) => ProductorViajeMapPage(),
        'productor/edit' : (BuildContext context) => ProductorEditPage(),
        'productor/travel/calification' : (BuildContext context) => ProductorViajeCalificationPage(),
        'productor/ingresop' : (BuildContext context) => ProductorIngresopPage(),
        'productor/history' : (BuildContext context) => ProductorHistoryPage(),
        'productor/history/detail' : (BuildContext context) => ProductorHistoryDetailPage(),
      }
    );
  }
}

