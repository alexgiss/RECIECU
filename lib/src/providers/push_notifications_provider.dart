import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:local/src/providers/productor_provider.dart';
import 'package:local/src/providers/reciclador_provider.dart';
import 'package:http/http.dart' as http;
import 'package:local/src/utils/shared_pref.dart';

class PushNotificationsProvider {

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  StreamController<Map<String, dynamic>> _streamController = StreamController<Map<String, dynamic>>.broadcast();


  Stream<Map<String, dynamic>> get message => _streamController.stream ;



  void initPushNotifications() {
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message) {
      if(message != null){
        Map<String, dynamic> data = message.data;
        SharedPref sharedPref= new SharedPref();
        sharedPref.save('isNotification', 'true');
        _streamController.sink.add(data);
      }


    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification.android;
      Map<String, dynamic> data = message.data;
      print('Cuando estamos en primer plano');
      print('OnResume: $data');
      _streamController.sink.add(data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Map<String, dynamic> data = message.data;

      print('OnMessage: $data');
      _streamController.sink.add(data);
    });


  }
  void saveToken(String idUser, String typeUser) async {
    String token = await _firebaseMessaging.getToken();
    Map<String, dynamic> data = {
      'token': token
    };

    if (typeUser == 'productor') {
      ProductorProvider productorProvider = new ProductorProvider();
      productorProvider.update(data, idUser);
    }
    else {
      RecicladorProvider recicladorProvider = new RecicladorProvider();
      recicladorProvider.update(data, idUser);
    }

  }
  Future<void> sendMessage(String to, Map<String, dynamic> data, String title, String body) async {
    await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String> {
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAAE-yOGQ:APA91bHBk8Yx3-SQDzs65NeTtpE0VdEdsbZl7Lcn8BMWEncaqzYeUedAQ9gQ-vWj4uW1_AHaeXPULtL1uQNmXfLQKx1BQJQ9Y5kkqneuUATg4TXBle6_Xj0nCVsVjm5cR9Z0_9yu2dtC'
        },
        body: jsonEncode(
            <String, dynamic> {
              'notification': <String, dynamic> {
                'body': body,
                'title': title,
              },
              'priority': 'high',
              'ttl': '4500s',
              'data': data,
              'to': to
            }
        )
    );
  }

}