import 'package:flutter/material.dart';
import 'package:spendsmart/screens/login_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 2), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  const LoginScreen(),));
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const[
          Icon(Icons.account_balance_wallet, size: 80, color: Colors.white),
          SizedBox(height: 16),
          Text('SpendSmart',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),),
          SizedBox(height: 8,),
          Text('Track. Save. Grow.',
          style: TextStyle(fontSize: 16, color: Colors.white70),)
        ],
      ),)
    );
  }
}