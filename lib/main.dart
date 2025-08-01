import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dukascango/domain/bloc/blocs.dart';
import 'package:dukascango/domain/bloc/financial_reporting/financial_reporting_bloc.dart';
import 'package:dukascango/domain/bloc/invitation/invitation_bloc.dart';
import 'package:dukascango/domain/services/push_notification.dart';
import 'package:dukascango/presentation/screens/intro/checking_login_screen.dart';
 
PushNotification pushNotification = PushNotification();

Future<void> _firebaseMessagingBackground( RemoteMessage message ) async {

  await Firebase.initializeApp();

}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackground);
  pushNotification.initNotifacion();
  runApp(MyApp());
}
 

 
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    pushNotification.onMessagingListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark ));

    return MultiBlocProvider(
      providers: [ 
        BlocProvider(create: (context) => AuthBloc()..add(CheckLoginEvent())),
        BlocProvider(create: (context) => GeneralBloc()),
        BlocProvider(create: (context) => ProductsBloc()),
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => UserBloc()),
        BlocProvider(create: (context) => MylocationmapBloc()),
        BlocProvider(create: (context) => PaymentsBloc()),
        BlocProvider(create: (context) => OrdersBloc()),
        BlocProvider(create: (context) => DeliveryBloc()),
        BlocProvider(create: (context) => MapdeliveryBloc()),
        BlocProvider(create: (context) => MapclientBloc()),
        BlocProvider(create: (context) => SelfScanBloc()),
        BlocProvider(create: (context) => DashboardBloc()),
        BlocProvider(create: (context) => InventoryBloc()),
        BlocProvider(create: (context) => FinancialReportingBloc()),
        BlocProvider(create: (context) => InvitationBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DukaScanGO',
        home: CheckingLoginScreen(),
      ),
    );
  }
}