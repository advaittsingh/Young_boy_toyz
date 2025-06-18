import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../core/services/auth_service.dart';
import '../auth/login_screen.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset('assets/videos/ybt new intro 1.mp4');
    
    try {
      await _controller.initialize();
      await _controller.setLooping(false);
      await _controller.play();
      
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }

      // Listen for video completion
      _controller.addListener(() {
        if (_controller.value.position >= _controller.value.duration) {
          _navigateToNextScreen();
        }
      });
    } catch (e) {
      print('Error initializing video: $e');
      // If video fails to load, navigate after a delay
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          _navigateToNextScreen();
        }
      });
    }
  }

  void _navigateToNextScreen() {
    final authService = AuthService();
    if (authService.currentUserEmail == null) {
      // User is not logged in, navigate to login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      // User is logged in, navigate to home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _isVideoInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(
                color: Colors.white,
              ),
      ),
    );
  }
} 