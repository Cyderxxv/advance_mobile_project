import 'package:chatbot_ai/cores/store/store.dart';
import 'package:chatbot_ai/features/chat/pages/chat_home.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'onboarding.dart';

class SplashV2Screen extends StatefulWidget {
  const SplashV2Screen({super.key});

  @override
  State<SplashV2Screen> createState() => _SplashV2ScreenState();
}

class _SplashV2ScreenState extends State<SplashV2Screen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if(StoreData.instant.token.isEmpty){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
      }
      else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ChatHomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                'ByMax',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
