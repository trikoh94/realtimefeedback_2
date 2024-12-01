import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';


// Firebase 설정 - 웹에서 가져온 설정을 추가
const FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyAONJBoHU38aluyc9YkGBZxE7H_uF_gSro",
  authDomain: "realfeedback-2.firebaseapp.com",
  projectId: "realfeedback-2",
  storageBucket: "realfeedback-2.firebasestorage.app",
  messagingSenderId: "175259851258",
  appId: "1:175259851258:web:200d808444303a178f2c43",
  measurementId: "G-TXF14XYHTT",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp(options: firebaseOptions);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth with Google Sign-In',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins', // 기본 폰트 설정
      ),
      home: SplashScreen(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '806024416381-4jcu8lc7i6kuhdk70qhcsi9gfkd34cue.apps.googleusercontent.com',
  );

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        leading: Image.asset('lib/assets/logo2.png', // 로고 추가
            width: 40, height: 40),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            User? user = await signInWithGoogle();
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Google 로그인 실패")),
              );
            }
          },
          child: Text('Google 로그인'),
        ),
      ),
    );
  }
}
