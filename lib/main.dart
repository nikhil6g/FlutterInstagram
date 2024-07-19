import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/Screens/login_screen.dart';
import 'package:instagram_flutter/provider/user_provider.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_screen.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options:const FirebaseOptions(
       apiKey: "AIzaSyCktOEKpJhGJwpRxLccOnXF_8JNYqDJLlQ",
       appId: "1:987434846603:web:734366d162f97fa44e078e", 
       messagingSenderId: "987434846603", 
       projectId: "instagram-flutter-f394a",
       storageBucket: "instagram-flutter-f394a.appspot.com",
       authDomain: "instagram-flutter-f394a.firebaseapp.com",
      )
    );
  }else{
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {
    return /*MaterialApp(
      home: LoginScreen(),
    );*/MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (_) =>UserProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram clone',
        theme: ThemeData.dark(),
        home:StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.active){
              if(snapshot.hasData && !AuthMethods.first){
                //debugPrint('call from main function');
                return const ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(), 
                  mobileScreenLayout: MobileScreenLayout()
                );
              }else if(snapshot.hasError){
                return Center(
                  child:Text('${snapshot.error}')
                );
              }
              
            }
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
            return const LoginScreen();
          }
        ),
      ),
    );
  }
}