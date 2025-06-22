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
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _setupSplashFlow();
  }

  Future<void> _setupSplashFlow() async {
    final authService = AuthService();
    await authService.initialize(); // ensure SharedPreferences and user state is loaded
    _isLoggedIn = await authService.isUserLoggedIn(); // check login state
    await _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset('assets/videos/ybt_intro_1.mp4');

    try {
      await _controller.initialize();
      setState(() {
        _isVideoInitialized = true;
      });

      await _controller.setLooping(false);
      await _controller.play();

      _controller.addListener(() {
        if (_controller.value.position >= _controller.value.duration &&
            !_hasNavigated) {
          _hasNavigated = true;
          _navigateToNextScreen();
        }
      });
    } catch (e) {
      debugPrint('Video load failed: $e');
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && !_hasNavigated) {
          _hasNavigated = true;
          _navigateToNextScreen();
        }
      });
    }
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => _isLoggedIn ? const HomeScreen() : const LoginScreen(),
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
