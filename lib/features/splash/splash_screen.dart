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
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset('assets/videos/ybt_intro_1.mp4'); // ✅ Rename your file!

    try {
      await _controller.initialize();
      setState(() {
        _isVideoInitialized = true;
      });

      _controller.play();
      _controller.setLooping(false);

      // Add listener for end of video
      _controller.addListener(() {
        if (_controller.value.position >= _controller.value.duration &&
            !_hasNavigated) {
          _hasNavigated = true;
          _navigateToNextScreen();
        }
      });
    } catch (e) {
      print('Video load failed: $e');
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && !_hasNavigated) {
          _hasNavigated = true;
          _navigateToNextScreen();
        }
      });
    }
  }

  void _navigateToNextScreen() {
    final authService = AuthService();
    final isLoggedIn = authService.currentUserEmail != null;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => isLoggedIn ? const HomeScreen() : const LoginScreen(),
      ),
    );
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
            : const CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
